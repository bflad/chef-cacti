name 'cacti'
maintainer 'Brian Flad'
maintainer_email 'bflad417@gmail.com'
license 'Apache 2.0'
description 'Cookbook for installing/configuring Cacti'
version '0.6.0'
recipe 'cacti', 'Installs/configures Cacti'
recipe 'cacti::apache2', 'Installs/configures Apache 2 and PHP for Cacti'
recipe 'cacti::cli_executable', 'Ensures Cacti CLI scripts are executable'
recipe 'cacti::configuration', 'Configures Cacti configuration files'
recipe 'cacti::cron', 'Installs Cacti polling cron entry'
recipe 'cacti::database', 'Installs/configures Cacti MySQL server'
recipe 'cacti::package', 'Installs Cacti via packages'
recipe 'cacti::spine', 'Installs Spine for Cacti server'

%w(apt build-essential cron yum-epel).each do |d|
  depends d
end
depends 'apache2', '~> 1.0'
depends 'database', '2.3.1'
depends 'mysql', '~> 5.0'

%w(centos fedora redhat).each do |os|
  supports os
end
