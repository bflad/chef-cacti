settings = Cacti.settings(node)

if settings['database']['host'] == 'localhost'
  include_recipe 'mysql::server'
  include_recipe 'database::mysql'

  database_connection = {
    :host => settings['database']['host'],
    :port => settings['database']['port'],
    :username => value_for_platform(
      %w(pld) => {
        'default' => 'mysql'
      },
      %w(centos fedora redhat ubuntu) => {
        'default' => 'root'
      }
    ),
    :password => node['mysql']['server_root_password']
  }

  mysql_database settings['database']['name'] do
    connection database_connection
    action :create
    notifies :run, 'execute[setup_cacti_database]', :immediately
  end

  cacti_sql_dir = value_for_platform(
    %w(ubuntu) => {
      'default' => '/usr/share/doc/cacti'
    },
    %w(pld) => {
      'default' => '/usr/share/cacti/sql'
    },
    %w(centos fedora redhat) => {
      'default' => "/usr/share/doc/cacti-#{node['cacti']['version']}"
    }
  )

  execute 'setup_cacti_database' do
    cwd cacti_sql_dir
    command "mysql -u #{database_connection[:username]} -p#{database_connection[:password]} #{settings['database']['name']} < cacti.sql"
    action :nothing
  end

  # See this MySQL bug: http://bugs.mysql.com/bug.php?id=31061
  mysql_database_user '' do
    connection database_connection
    host 'localhost'
    action :drop
  end

  mysql_database_user settings['database']['user'] do
    connection database_connection
    host '%'
    password settings['database']['password']
    database_name settings['database']['name']
    action [:create, :grant]
  end

  # Configure base Cacti settings in database
  mysql_database 'configure_cacti_database_settings' do
    connection database_connection
    database_name settings['database']['name']

    cacti_log_path = value_for_platform(
      %w(pld) => {
        'default' => '/var/log/cacti/cacti.log'
      },
      %w(centos fedora redhat ubuntu) => {
        'default' => '/usr/share/cacti/log/cacti.log'
      }
    )

    sql <<-SQL
      INSERT INTO `settings` (`name`,`value`) VALUES ("path_rrdtool","/usr/bin/rrdtool") ON DUPLICATE KEY UPDATE `value`="/usr/bin/rrdtool";
      INSERT INTO `settings` (`name`,`value`) VALUES ("path_php_binary","/usr/bin/php") ON DUPLICATE KEY UPDATE `value`="/usr/bin/php";
      INSERT INTO `settings` (`name`,`value`) VALUES ("path_snmpwalk","/usr/bin/snmpwalk") ON DUPLICATE KEY UPDATE `value`="/usr/bin/snmpwalk";
      INSERT INTO `settings` (`name`,`value`) VALUES ("path_snmpget","/usr/bin/snmpget") ON DUPLICATE KEY UPDATE `value`="/usr/bin/snmpget";
      INSERT INTO `settings` (`name`,`value`) VALUES ("path_snmpbulkwalk","/usr/bin/snmpbulkwalk") ON DUPLICATE KEY UPDATE `value`="/usr/bin/snmpbulkwalk";
      INSERT INTO `settings` (`name`,`value`) VALUES ("path_snmpgetnext","/usr/bin/snmpgetnext") ON DUPLICATE KEY UPDATE `value`="/usr/bin/snmpgetnext";
      INSERT INTO `settings` (`name`,`value`) VALUES ("path_cactilog","#{cacti_log_path}") ON DUPLICATE KEY UPDATE `value`="#{cacti_log_path}";
      INSERT INTO `settings` (`name`,`value`) VALUES ("snmp_version","net-snmp") ON DUPLICATE KEY UPDATE `value`="net-snmp";
      INSERT INTO `settings` (`name`,`value`) VALUES ("rrdtool_version","rrd-#{node['cacti']['rrdtool']['version']}.x") ON DUPLICATE KEY UPDATE `value`="rrd-#{node['cacti']['rrdtool']['version']}.x";
      INSERT INTO `settings` (`name`,`value`) VALUES ("path_webroot","/usr/share/cacti") ON DUPLICATE KEY UPDATE `value`="/usr/share/cacti";
      UPDATE `user_auth` SET `password`=md5('#{settings['admin']['password']}'), `must_change_password`="" WHERE `username`='admin';
      UPDATE `version` SET `cacti`="#{node['cacti']['version']}";
    SQL
    action :query
  end
end
