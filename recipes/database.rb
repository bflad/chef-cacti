settings = Cacti.settings(node)

if settings['database']['host'] == 'localhost' || settings['database']['host'] == '127.0.0.1'
  mysql2_chef_gem 'default' do
    provider Chef::Provider::Mysql2ChefGem::Percona if node['cacti']['mysql_provider'] == 'percona'
    action :install
  end

  if node['cacti']['mysql_provider'] == 'percona'
    include_recipe 'percona::client'
    include_recipe 'percona::server'
  else
    mysql_client 'default' do   
      action :create   
    end

    mysql_service 'cacti' do
      port settings['database']['port']
      version value_for_platform(
        'ubuntu' => {
          %w(12.04 12.10 13.04 13.10) => '5.5',
          'default' => '5.6'
        },
        'default' => '5.5'
      )
      initial_root_password node['mysql']['server_root_password']
      action [:create, :start]
    end
  end

  database_connection = {
    :host => settings['database']['host'],
    :port => settings['database']['port'],
    :username => value_for_platform(
      %w(pld) => {
        'default' => 'mysql'
      },
      %w(centos debian fedora redhat ubuntu) => {
        'default' => 'root'
      }
    ),
    :password => node['mysql']['server_root_password']
  }
  mysql_cli_opts = "mysql -h #{database_connection[:host]} -u #{database_connection[:username]} -p#{database_connection[:password]} #{settings['database']['name']}"

  mysql_database settings['database']['name'] do
    connection database_connection
    action :create
    notifies :run, 'execute[setup_cacti_database]', :immediately
  end

  execute 'setup_cacti_database' do
    cwd Cacti.sql_dir(node)
    command "#{mysql_cli_opts} < cacti.sql"
    action :nothing
  end

  # See this MySQL bug: http://bugs.mysql.com/bug.php?id=31061
  mysql_database_user '' do
    connection database_connection
    host 'localhost'
    action :drop
  end

  log "Creating database user"
  mysql_database_user settings['database']['user'] do
    connection database_connection
    host '%'
    password settings['database']['password']
    database_name settings['database']['name']
    action [:create, :grant]
  end

  template "#{Cacti.sql_dir(node)}/db-settings.sql" do
    source 'db-settings.sql.erb'
    owner node['cacti']['user']
    group node['cacti']['group']
    mode 00640
    variables(
      :settings => settings
    )
    notifies :run, 'execute[setup_cacti_settings]', :immediately
  end

  execute 'setup_cacti_settings' do
    cwd Cacti.sql_dir(node)
    command "#{mysql_cli_opts} < db-settings.sql"
    action :nothing
  end
end
