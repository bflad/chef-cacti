name              "cacti"
maintainer        "Brian Flad"
maintainer_email  "bflad417@gmail.com"
license           "Apache 2.0"
description       "Cookbook for installing/configuring Cacti."
version           "0.2.0"
recipe            "cacti", "Empty recipe."
recipe            "cacti::server", "Installs Cacti server."
recipe            "cacti::spine", "Installs Spine for Cacti server."

%w{ apache2 build-essential cron database mysql }.each do |d|
  depends d
end

%w{ centos redhat ubuntu }.each do |os|
  supports os
end
