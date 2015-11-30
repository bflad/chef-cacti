settings = Cacti.settings(node)

# Install Spine dependencies
include_recipe 'build-essential'

node['cacti']['spine']['packages'].each do |p|
  package p
end

remote_file "#{Chef::Config[:file_cache_path]}/cacti-spine-#{node['cacti']['version']}.tar.gz" do
  source Cacti.spine_url(node)
  checksum Cacti.spine_checksum(node)
  mode '0644'
  action :create_if_missing
end

execute "install_cacti_spine_#{node['cacti']['version']}" do
  cwd Chef::Config[:file_cache_path]
  command <<-COMMAND
    tar -zxf cacti-spine-#{node['cacti']['version']}.tar.gz
    cd cacti-spine-#{node['cacti']['version']}
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
