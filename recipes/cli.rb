# recipe to test cacti_device and cacti_graph resources
cacti_device node['fqdn'] do
  ip node['ipaddress']

  notes 'Test Host'
  disable false

  # [ping][none, snmp, pingsnmp]
  avail 'pingsnmp'

  # ping_method  tcp, icmp|tcp|udp
  ping_method 'udp'

  # ping_port '', 1-65534
  ping_port 23

  # the number of time to attempt to communicate with a host
  ping_retries  3

  # snmp version (1|2|3)
  version 2

  # snmp community string for snmpv1 and snmpv2. Leave blank for no community
  community 'sw'

  # snmp port
  port  161
  # snmp timeout
  timeout 500

  # snmp username for snmpv3
  username  'un'
  # snmp password for snmpv3
  password  'pw'
  # snmp authentication protocol for snmpv3
  authproto 'xxxx'
  # snmp privacy passphrase for snmpv3
  privpass  'pp'
  # snmp privacy protocol for snmpv3
  privproto 'xx'
  # snmp context for snmpv3
#  context ''
  # the number of OID's that can be obtained in a single SNMP Get request (1-60)
  max_oids  32
end

[
  'TCP Connections',
  'ucd 00 CPU',
  'ucd 01 Load Average',
  'ucd 11 Swap',
  'ucd 12 Detailled Memory',
  'ucd 20 Processes',
  'ucd 30 Users',
].each do |graph|
  cacti_graph graph do
    graph_type 'cg'
    host node['fqdn']
  end
end

# graph with input fields
cacti_graph 'PHP-FPM Pool Status' do
  graph_type 'cg'
  host node['fqdn']
  input_fields :port=>1028, :script=>'/fpm-status', 'querystring'=>'', 'mode'=>'fcgi'
end

# collect unique mount points
# as ohai collect info from various sources, there are duplicates
# also skip fs_type=tmpfs
fs = node['filesystem']
  .map { |_, fs| fs['fs_type'] != 'tmpfs' ? fs['mount'] : nil }
  .compact.uniq

# monitor each partition
fs.each do |mount|
  cacti_graph "ucd 90 Filesystems #{mount}" do
    graph_template 'ucd 90 Filesystems'
    graph_type 'ds'
    host node['fqdn']
    snmp_query 'SNMP - Get Mounted Partitions'
    snmp_query_type 'Available Disk Space'
    snmp_field 'hrStorageDescr'
    snmp_value mount
  end
end

# Create All hosts->Linux nodes->node
cacti_tree 'All hosts' do
  type 'tree'
  sort_method 'natural'
end

# Add "header" under "All hosts"
cacti_tree 'Linux nodes' do
  type 'node'
  node_type 'header'
  tree_id 'All hosts'
  sort_method 'alpha'
end

# Add "host" under "Linux nodes" node
cacti_tree node['fqdn'] do
  type 'node'
  node_type 'host'
  tree_id 'All hosts'
  parent_node 'Linux nodes'

  host_id node['fqdn']
end

# Add CPU "Graph" under "Linux nodes"
cacti_tree node['fqdn'] do
  type 'node'
  node_type 'graph'
  tree_id 'All hosts'
  parent_node 'Linux nodes'

  host_id node['fqdn']
  graph_id "#{node['fqdn']} - CPU Usage"
  rra_id 'Daily (5 Minute Average)'
end
