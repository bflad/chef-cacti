settings = Cacti.settings(node)

user node['cacti']['user'] do
	gid node['cacti']['gid'] if node['cacti']['gid']
	uid node['cacti']['uid'] if node['cacti']['uid']
end

if node['cacti']['gid']
  group node['cacti']['group'] do
    gid node['cacti']['gid']
    members [
      node['cacti']['user']
    ]
  end
end

directory '/var/lib/cacti/rra' do
  mode 00775
  owner node['cacti']['user']
  group node['cacti']['group']
end

template node['cacti']['db_file'] do
  source 'db.php.erb'
  owner node['cacti']['user']
  group node['cacti']['group']
  mode 00640
  variables(
    :database => settings['database']
  )
end
