settings = Cacti.settings(node)

include_recipe 'apt' if node['platform'] == 'ubuntu'
include_recipe 'yum-epel' if node['platform_family'] == 'rhel'
include_recipe 'cacti::package'
include_recipe 'cacti::database'
include_recipe 'cacti::configuration'
include_recipe 'cacti::apache2'
include_recipe 'cacti::cron'
