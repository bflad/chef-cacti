include 'percona::client' if node['cacti']['mysql_provider'] == 'percona'

mysql2_chef_gem 'default' do
  provider Chef::Provider::Mysql2ChefGem::Percona if node['cacti']['mysql_provider'] == 'percona'
  action :install
end

mysql_client 'default' do   
  action :create   
end
