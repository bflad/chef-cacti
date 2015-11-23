settings = Cacti.settings(node)

user "cacti" do
	action :create
	uid 6666
	gid 6666
end

group "cacti" do
  action :create
  gid 6666
  members ["cacti", "www-data"]
end

directory "/var/lib/cacti/rra" do
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
    :database => node['cacti']['database']
  )
end
