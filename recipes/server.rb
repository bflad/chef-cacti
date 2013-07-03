#
# Cookbook Name:: cacti
# Recipe:: server
#
# Contributors Brian Flad
# Copyright 2013
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Load Cacti data bag
cacti_data_bag = Chef::EncryptedDataBagItem.load("cacti","server")
cacti_admin_info = cacti_data_bag[node.chef_environment]['admin']
cacti_database_info = cacti_data_bag[node.chef_environment]['database']

# Install Cacti and dependencies
include_recipe "apache2"
include_recipe "apache2::mod_php5"
include_recipe "apache2::mod_rewrite"
include_recipe "apache2::mod_ssl"
include_recipe "mysql::client"

if node['platform'] == 'ubuntu'
  %w{ cacti libsnmp-base libsnmp15 snmp snmpd libnet-ldap-perl libnet-snmp-perl php-net-ldap php5-mysql php-apc php5-snmp }.each do |p|
    package p
  end
else
  %w{ cacti net-snmp net-snmp-utils perl-LDAP perl-Net-SNMP php-ldap php-mysql php-pecl-apc php-snmp }.each do |p|
    package p
  end
end

if cacti_database_info['host'] == "localhost"
  include_recipe "mysql::server"
  include_recipe "database::mysql"
  
  cacti_database_info['port'] ||= 3306
  database_connection = {
    :host => cacti_database_info['host'],
    :port => cacti_database_info['port'],
    :username => 'root',
    :password => node['mysql']['server_root_password']
  }
  
  mysql_database cacti_database_info['name'] do
    connection database_connection
    action :create
    notifies :run, "execute[setup_cacti_database]", :immediately
  end

  if node['platform'] == 'ubuntu'
    cacti_sql_dir = "/usr/share/doc/cacti"
  else
    cacti_sql_dir = "/usr/share/doc/cacti-#{node['cacti']['version']}"
  end

  execute "setup_cacti_database" do
    cwd cacti_sql_dir
    command "mysql -u root -p#{node['mysql']['server_root_password']} #{cacti_database_info['name']} < cacti.sql"
    action :nothing
  end

  # See this MySQL bug: http://bugs.mysql.com/bug.php?id=31061
  mysql_database_user "" do
    connection database_connection
    host "localhost"
    action :drop
  end
  
  mysql_database_user cacti_database_info['user'] do
    connection database_connection
    host "%"
    password cacti_database_info['password']
    database_name cacti_database_info['name']
    action [:create, :grant]
  end

  # Configure base Cacti settings in database
  mysql_database "configure_cacti_database_settings" do
    connection database_connection
    database_name cacti_database_info['name']
    sql <<-SQL
      INSERT INTO `settings` (`name`,`value`) VALUES ("path_rrdtool","/usr/bin/rrdtool") ON DUPLICATE KEY UPDATE `value`="/usr/bin/rrdtool";
      INSERT INTO `settings` (`name`,`value`) VALUES ("path_php_binary","/usr/bin/php") ON DUPLICATE KEY UPDATE `value`="/usr/bin/php";
      INSERT INTO `settings` (`name`,`value`) VALUES ("path_snmpwalk","/usr/bin/snmpwalk") ON DUPLICATE KEY UPDATE `value`="/usr/bin/snmpwalk";
      INSERT INTO `settings` (`name`,`value`) VALUES ("path_snmpget","/usr/bin/snmpget") ON DUPLICATE KEY UPDATE `value`="/usr/bin/snmpget";
      INSERT INTO `settings` (`name`,`value`) VALUES ("path_snmpbulkwalk","/usr/bin/snmpbulkwalk") ON DUPLICATE KEY UPDATE `value`="/usr/bin/snmpbulkwalk";
      INSERT INTO `settings` (`name`,`value`) VALUES ("path_snmpgetnext","/usr/bin/snmpgetnext") ON DUPLICATE KEY UPDATE `value`="/usr/bin/snmpgetnext";
      INSERT INTO `settings` (`name`,`value`) VALUES ("path_cactilog","/usr/share/cacti/log/cacti.log") ON DUPLICATE KEY UPDATE `value`="/usr/share/cacti/log/cacti.log";
      INSERT INTO `settings` (`name`,`value`) VALUES ("snmp_version","net-snmp") ON DUPLICATE KEY UPDATE `value`="net-snmp";
      INSERT INTO `settings` (`name`,`value`) VALUES ("rrdtool_version","rrd-1.3.x") ON DUPLICATE KEY UPDATE `value`="rrd-1.3.x";
      INSERT INTO `settings` (`name`,`value`) VALUES ("path_webroot","/usr/share/cacti") ON DUPLICATE KEY UPDATE `value`="/usr/share/cacti";
      UPDATE `user_auth` SET `password`=md5('#{cacti_admin_info['password']}'), `must_change_password`="" WHERE `username`='admin';
      UPDATE `version` SET `cacti`="#{node['cacti']['version']}";
    SQL
    action :query
  end
end

if node['platform'] == 'ubuntu'
  dbconfig = "/etc/cacti/debian.php"
else
  dbconfig = "/etc/cacti/db.php"
end

template dbconfig do
  source "db.php.erb"
  owner node['cacti']['user']
  group node['cacti']['group']
  mode 00640
  variables({
    :database => cacti_database_info
  })
end

template "#{node['cacti']['apache2']['conf_dir']}/cacti.conf" do
  source "cacti.conf.erb"
  owner "root"
  group "root"
  mode 00644
  notifies :reload, "service[apache2]", :delayed
end

web_app "cacti" do
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
  cron_d "cacti" do
    minute node['cacti']['cron_minute']
    command "/usr/bin/php /usr/share/cacti/site/poller.php > /dev/null 2>&1"
    user node['cacti']['user']
  end
else
  cron_d "cacti" do
    minute node['cacti']['cron_minute']
    command "/usr/bin/php /usr/share/cacti/poller.php > /dev/null 2>&1"
    user node['cacti']['user']
  end
end
