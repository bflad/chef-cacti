settings = Cacti.settings(node)

if settings['database']['host'] == 'localhost'
  include_recipe "#{node['cacti']['mysql_provider']}::server"

  # Required by database cookbook
  mysql2_chef_gem 'default' do
    provider Chef::Provider::Mysql2ChefGem::Percona if node.cacti.mysql_provider == 'percona'
    action :install
  end

  database_connection = {
    :host => settings['database']['host'],
    :port => settings['database']['port'],
    :username => value_for_platform(
      %w(pld) => {
        'default' => 'mysql'
      },
      %w(centos fedora redhat ubuntu debian) => {
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
    %w(ubuntu debian) => {
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
  cacti_log_path = value_for_platform(
    %w(pld) => {
      'default' => '/var/log/cacti/cacti.log'
    },
    %w(centos fedora redhat ubuntu debian) => {
      'default' => '/usr/share/cacti/log/cacti.log'
    }
  )

  template '/tmp/config.sql' do
    source 'config.sql.erb'
    variables :cacti_log_path => cacti_log_path,
              :settings => settings
    notifies :run, 'bash[import-cacti-settings-into-db]', :immediately
  end

  bash 'import-cacti-settings-into-db' do
    user 'root'
    code "mysql #{settings['database']['name']} < /tmp/config.sql"
    action :nothing
  end

  file '/tmp/config.sql' do
    action :delete
  end
end
