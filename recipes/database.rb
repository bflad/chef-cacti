settings = Cacti.settings(node)

if settings['database']['host'] == 'localhost' || settings['database']['host'] == '127.0.0.1'
  include_recipe 'cacti::database_client'

  if node['cacti']['mysql_provider'] == 'percona'
    include_recipe 'percona::server'
  else
    mysql_service 'cacti' do
      port settings['database']['port']
      version '5.5'
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
    cwd node['cacti']['sql_dir']
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

  template "#{node['cacti']['sql_dir']}/db-settings.sql" do
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
    cwd node['cacti']['sql_dir']
    command "#{mysql_cli_opts} < db-settings.sql"
    action :nothing
  end
end
