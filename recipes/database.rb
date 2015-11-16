settings = Cacti.settings(node)

mysql2_chef_gem 'default' do
  action :install
end

mysql_client 'default' do   
  action :create   
end

if settings['database']['host'] == 'localhost' || settings['database']['host'] == '127.0.0.1'

  mysql_service 'cacti' do
    port '3306'
    version '5.5'
    initial_root_password node['mysql']['server_root_password']
    action [:create, :start]
  end

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
    command "mysql -h #{database_connection[:host]} -u #{database_connection[:username]} -p#{database_connection[:password]} #{settings['database']['name']} < cacti.sql"
    action :nothing
  end

  log "Creating database user"
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
      UPDATE `user_auth` SET `password`=md5('#{settings['admin']['password']}'), `must_change_password`='' WHERE `username`='admin';
    SQL
    action :query
  end
end
