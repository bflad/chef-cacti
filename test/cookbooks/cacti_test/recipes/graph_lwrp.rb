graphs = value_for_platform(
  %w(pld) => {
    'default' => [
      'TCP Connections',
      'ucd 00 CPU',
      'ucd 01 Load Average',
      'ucd 11 Swap',
      'ucd 12 Detailled Memory',
      'ucd 20 Processes',
      'ucd 30 Users'
    ]
  },
  'default' => [
    'Interface - Traffic (bits/sec)',
    'ucd/net - CPU Usage',
    'Unix - Load Average',
    'ucd/net - Memory Usage',
    'Unix - Processes',
    'Unix - Logged in Users'
  ]
  )
filesystems_graph_template_id = value_for_platform(
  %w(pld) => {
    'default' => 'ucd 90 Filesystems'
  },
  'default' => 'ucd/net - Available Disk Space'
  )

graphs.each do |graph|
  cacti_graph graph do
    graph_type 'cg'
    host_id node['fqdn']
  end
end

if node['platform'] == 'pld'
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
    cacti_graph "#{filesystems_graph_template_id} #{mount}" do
      graph_template_id filesystems_graph_template_id
      graph_type 'ds'
      host_id node['fqdn']
      snmp_query_id 'SNMP - Get Mounted Partitions'
      snmp_query_type_id 'Available Disk Space'
      snmp_field 'hrStorageDescr' if node['platform'] == 'pld'
      snmp_value mount
    end
  end
end
