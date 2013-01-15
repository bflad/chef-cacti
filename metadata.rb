name              "cacti"
maintainer        "Brian Flad"
maintainer_email  "bflad@wharton.upenn.edu"
license           "Apache 2.0"
description       "Cookbook for installing/configuring Cacti."
version           "0.1.0"
recipe            "cacti", "Empty recipe."
recipe            "cacti::server", "Installs Cacti server."
recipe            "cacti::spine", "Installs Spine for Cacti server."

%w{ apache2 build-essentials cron database mysql }.each do |d|
  depends d
end

%w{ redhat }.each do |os|
  supports os
end
