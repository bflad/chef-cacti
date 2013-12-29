# Load Cacti data bag
cacti_data_bag = Chef::EncryptedDataBagItem.load('cacti', 'server')
cacti_database_info = cacti_data_bag[node.chef_environment]['database']

template node['cacti']['db_file'] do
  source 'db.php.erb'
  owner node['cacti']['user']
  group node['cacti']['group']
  mode 00640
  variables(
    :database => cacti_database_info
  )
end
