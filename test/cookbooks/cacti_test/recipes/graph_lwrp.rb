[
  'TCP Connections',
  'ucd 00 CPU',
  'ucd 01 Load Average',
  'ucd 11 Swap',
  'ucd 12 Detailled Memory',
  'ucd 20 Processes',
  'ucd 30 Users'
].each do |graph|
  cacti_graph graph do
    graph_type 'cg'
    host_id node['fqdn']
  end
end

# graph with input fields
cacti_graph 'PHP-FPM Pool Status' do
  graph_type 'cg'
  host_id node['fqdn']
  input_fields :port => 1028, :script => '/fpm-status', 'querystring' => '', 'mode' => 'fcgi'
end

# collect unique mount points
# as ohai collect info from various sources, there are duplicates
# also skip fs_type=tmpfs
filesystems = node['filesystem']
  .map { |_, fs| fs['fs_type'] != 'tmpfs' ? fs['mount'] : nil }
  .compact.uniq

# monitor each partition
filesystems.each do |mount|
  cacti_graph "ucd 90 Filesystems #{mount}" do
    graph_template_id 'ucd 90 Filesystems'
    graph_type 'ds'
    host_id node['fqdn']
    snmp_query_id 'SNMP - Get Mounted Partitions'
    snmp_query_type_id 'Available Disk Space'
    snmp_field 'hrStorageDescr'
    snmp_value mount
  end
end
