# Load Cacti data bag
cacti_data_bag = Chef::EncryptedDataBagItem.load('cacti', 'server')
cacti_database_info = cacti_data_bag[node.chef_environment]['database']

# Install Cacti and dependencies
include_recipe 'mysql::client'

if node['platform'] == 'ubuntu'
  %w{ cacti libsnmp-base libsnmp15 snmp snmpd libnet-ldap-perl libnet-snmp-perl php-net-ldap php5-mysql php-apc php5-snmp }.each do |p|
    package p
  end
else
  %w{ cacti net-snmp net-snmp-utils perl-LDAP perl-Net-SNMP php-ldap php-mysql php-pecl-apc php-snmp }.each do |p|
    package p
  end
end

template node['cacti']['db_file'] do
  source 'db.php.erb'
  owner node['cacti']['user']
  group node['cacti']['group']
  mode 00640
  variables(
    :database => cacti_database_info
  )
end

cron_d 'cacti' do
  minute node['cacti']['cron_minute']
  command "/usr/bin/php #{node['cacti']['poller_file']} > /dev/null 2>&1"
  user node['cacti']['user']
end
