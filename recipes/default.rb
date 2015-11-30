settings = Cacti.settings(node)

include_recipe 'apt' if node['platform'] == 'ubuntu'
include_recipe 'yum-epel' if node['platform_family'] == 'rhel'
include_recipe 'mysql::client'
include_recipe 'cacti::package'
include_recipe 'cacti::database' if settings['database']['host'] == 'localhost'
include_recipe 'cacti::configuration'
include_recipe 'cacti::apache2'
include_recipe 'cacti::cron'
include_recipe 'cacti::cli_executable'
