settings = Cacti.settings(node)

group "cacti" do
	action :create
	gid 6666
end

user "cacti" do
	action :create
	uid 6666
	gid 6666
end

execute "set cacti permissions" do
  command "chown -R cacti:cacti /var/lib/cacti"
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
