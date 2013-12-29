# Load Cacti data bag
cacti_data_bag = Chef::EncryptedDataBagItem.load('cacti', 'server')
cacti_admin_info = cacti_data_bag[node.chef_environment]['admin']
cacti_database_info = cacti_data_bag[node.chef_environment]['database']

if cacti_database_info['host'] == 'localhost'
  include_recipe 'mysql::server'
  include_recipe 'database::mysql'

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
    notifies :run, 'execute[setup_cacti_database]', :immediately
  end

  if node['platform'] == 'ubuntu'
    cacti_sql_dir = '/usr/share/doc/cacti'
  else
    cacti_sql_dir = "/usr/share/doc/cacti-#{node['cacti']['version']}"
  end

  execute 'setup_cacti_database' do
    cwd cacti_sql_dir
    command "mysql -u root -p#{node['mysql']['server_root_password']} #{cacti_database_info['name']} < cacti.sql"
    action :nothing
  end

  # See this MySQL bug: http://bugs.mysql.com/bug.php?id=31061
  mysql_database_user '' do
    connection database_connection
    host 'localhost'
    action :drop
  end

  mysql_database_user cacti_database_info['user'] do
    connection database_connection
    host '%'
    password cacti_database_info['password']
    database_name cacti_database_info['name']
    action [:create, :grant]
  end

  # Configure base Cacti settings in database
  mysql_database 'configure_cacti_database_settings' do
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
