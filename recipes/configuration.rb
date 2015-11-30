settings = Cacti.settings(node)

user node['cacti']['user']

template node['cacti']['db_file'] do
  source 'db.php.erb'
  owner node['cacti']['user']
  group node['cacti']['group']
  mode 00640
  variables(
    :database => settings['database']
  )
end
