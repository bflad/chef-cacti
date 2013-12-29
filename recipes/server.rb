# Load Cacti data bag
cacti_data_bag = Chef::EncryptedDataBagItem.load('cacti', 'server')
cacti_admin_info = cacti_data_bag[node.chef_environment]['admin']
cacti_database_info = cacti_data_bag[node.chef_environment]['database']

# Install Cacti and dependencies
include_recipe 'apache2'
include_recipe 'apache2::mod_php5'
include_recipe 'apache2::mod_rewrite'
include_recipe 'apache2::mod_ssl'
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

if node['platform'] == 'ubuntu'
  dbconfig = '/etc/cacti/debian.php'
else
  dbconfig = '/etc/cacti/db.php'
end

template dbconfig do
  source 'db.php.erb'
  owner node['cacti']['user']
  group node['cacti']['group']
  mode 00640
  variables(
    :database => cacti_database_info
  )
end

template "#{node['cacti']['apache2']['conf_dir']}/cacti.conf" do
  source 'cacti.conf.erb'
  owner 'root'
  group 'root'
  mode 00644
  notifies :reload, 'service[apache2]', :delayed
end

web_app 'cacti' do
  server_name node['cacti']['apache2']['server_name']
  server_aliases node['cacti']['apache2']['server_aliases']
  doc_root node['cacti']['apache2']['doc_root']
  ssl_enabled node['cacti']['apache2']['ssl']['enabled']
  ssl_forced node['cacti']['apache2']['ssl']['force']
  ssl_certificate_file node['cacti']['apache2']['ssl']['certificate_file']
  ssl_chain_file node['cacti']['apache2']['ssl']['chain_file']
  ssl_key_file node['cacti']['apache2']['ssl']['key_file']
end

if node['platform'] == 'ubuntu'
  cron_d 'cacti' do
    minute node['cacti']['cron_minute']
    command '/usr/bin/php /usr/share/cacti/site/poller.php > /dev/null 2>&1'
    user node['cacti']['user']
  end
else
  cron_d 'cacti' do
    minute node['cacti']['cron_minute']
    command '/usr/bin/php /usr/share/cacti/poller.php > /dev/null 2>&1'
    user node['cacti']['user']
  end
end
