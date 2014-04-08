settings = Cacti.settings(node)

# Install Spine dependencies
include_recipe 'build-essential'
include_recipe 'mysql::client'

node['cacti']['spine']['packages'].each do |p|
  package p
end

remote_file "#{Chef::Config[:file_cache_path]}/cacti-spine-#{node['cacti']['spine']['version']}.tar.gz" do
  source node['cacti']['spine']['url']
  checksum node['cacti']['spine']['checksum']
  mode '0644'
  action :create_if_missing
end

execute "install_cacti_spine_#{node['cacti']['spine']['version']}" do
  cwd Chef::Config[:file_cache_path]
  command <<-COMMAND
    tar -zxf cacti-spine-#{node['cacti']['spine']['version']}.tar.gz
    cd cacti-spine-#{node['cacti']['spine']['version']}
    ./configure --build=x86_64-unknown-linux
    make
    chown root:root spine
    chmod u+s spine
    cp -p spine /usr/bin/spine
  COMMAND
  creates '/usr/bin/spine'
  action :run
end

template '/etc/spine.conf' do
  source 'spine.conf.erb'
  owner 'root'
  group 'root'
  mode 00644
  variables(
    :database => settings['database']
  )
end

if settings['database']['host'] == 'localhost'
  include_recipe 'database::mysql'

  database_connection = {
    :host => settings['database']['host'],
    :port => settings['database']['port'],
    :username => settings['database']['user'],
    :password => settings['database']['password']
  }

  # Configure Spine path and set poller type in database
  mysql_database 'configure_cacti_database_spine_settings' do
    connection database_connection
    database_name settings['database']['name']
    sql <<-SQL
      INSERT INTO `settings` (`name`,`value`) VALUES ("path_spine","/usr/bin/spine") ON DUPLICATE KEY UPDATE `value`="/usr/bin/spine";
      INSERT INTO `settings` (`name`,`value`) VALUES ("poller_type", 2) ON DUPLICATE KEY UPDATE `value`=2
    SQL
    action :query
  end
end
