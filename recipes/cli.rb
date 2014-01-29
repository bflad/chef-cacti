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

cacti_graph 'TCP Connections' do
  graph_type 'cg'
  host  node['fqdn']
end

[
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
