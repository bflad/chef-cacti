settings = Cacti.settings(node)

group "cacti" do
	action :create
	gid 9999
end

user "cacti" do
	action :create
	uid 9999
	gid 9999
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
