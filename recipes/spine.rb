#
# Cookbook Name:: cacti
# Recipe:: spine
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
cacti_database_info = cacti_data_bag[node.chef_environment]['database']

# Install Spine dependencies
include_recipe "build-essential"
include_recipe "mysql::client"

if node['platform'] == 'ubuntu'
  %w{ libsnmp-dev libssl-dev }.each do |p|
    package p
  end
else
  %w{ net-snmp-devel openssl-devel }.each do |p|
    package p
  end
end

remote_file "#{Chef::Config[:file_cache_path]}/cacti-spine-#{node["cacti"]["spine"]["version"]}.tar.gz" do
  source    node["cacti"]["spine"]["url"]
  checksum  node["cacti"]["spine"]["checksum"]
  mode      "0644"
  action    :create_if_missing
end

execute "install_cacti_spine_#{node["cacti"]["spine"]["version"]}" do
  cwd Chef::Config[:file_cache_path]
  command <<-COMMAND
    tar -zxf cacti-spine-#{node["cacti"]["spine"]["version"]}.tar.gz
    cd cacti-spine-#{node["cacti"]["spine"]["version"]}
    ./configure --build=x86_64-unknown-linux
    make
    chown root:root spine
    chmod u+s spine
    cp -p spine /usr/bin/spine
  COMMAND
  creates "/usr/bin/spine"
  action :run
end

template "/etc/spine.conf" do
  source "spine.conf.erb"
  owner "root"
  group "root"
  mode 00644
  variables({
    :database => cacti_database_info
  })
end

if cacti_database_info['host'] == "localhost"
  include_recipe "database::mysql"
  
  cacti_database_info['port'] ||= 3306
  database_connection = {
    :host => cacti_database_info['host'],
    :port => cacti_database_info['port'],
    :username => cacti_database_info['user'],
    :password => cacti_database_info['password']
  }

  # Configure Spine path and set poller type in database
  mysql_database "configure_cacti_database_spine_settings" do
    connection database_connection
    database_name cacti_database_info['name']
    sql <<-SQL
      INSERT INTO `settings` (`name`,`value`) VALUES ("path_spine","/usr/bin/spine") ON DUPLICATE KEY UPDATE `value`="/usr/bin/spine";
      INSERT INTO `settings` (`name`,`value`) VALUES ("poller_type", 2) ON DUPLICATE KEY UPDATE `value`=2
    SQL
    action :query
  end
end
