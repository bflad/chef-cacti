# Load Cacti data bag
cacti_data_bag = Chef::EncryptedDataBagItem.load('cacti', 'server')
cacti_database_info = cacti_data_bag[node.chef_environment]['database']

include_recipe 'mysql::client'
include_recipe 'cacti::database' if cacti_database_info['host'] == 'localhost'
include_recipe 'cacti::package'
include_recipe 'cacti::configuration'
include_recipe 'cacti::apache2'
include_recipe 'cacti::cron'
