cacti_data_query node['fqdn'] do
  host_id node['fqdn']
  data_query_id 'SNMP - Get Mounted Partitions'
  reindex_method 'None'
end
