name 'cacti'
maintainer 'Brian Flad'
maintainer_email 'bflad417@gmail.com'
license 'Apache 2.0'
description 'Cookbook for installing/configuring Cacti'
version '0.5.2'
recipe 'cacti', 'Installs/configures Cacti'
recipe 'cacti::apache2', 'Installs/configures Apache 2 and PHP for Cacti'
recipe 'cacti::configuration', 'Configures Cacti configuration files'
recipe 'cacti::cron', 'Installs Cacti polling cron entry'
recipe 'cacti::database', 'Installs/configures Cacti MySQL server'
recipe 'cacti::package', 'Installs Cacti via packages'
recipe 'cacti::spine', 'Installs Spine for Cacti server'

%w(apache2 apt build-essential cron database mysql yum-epel mysql2_chef_gem).each do |d|
  depends d
end

%w(centos fedora redhat ubuntu).each do |os|
  supports os
end
