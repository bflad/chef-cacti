# Install Cacti and dependencies
include_recipe 'mysql::client'

node['cacti']['packages'].each do |p|
  package p
end
