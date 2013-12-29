include_recipe 'apache2'
include_recipe 'apache2::mod_php5'
include_recipe 'apache2::mod_rewrite'
include_recipe 'apache2::mod_ssl'

template "#{node['cacti']['apache2']['conf_dir']}/cacti.conf" do
  source 'cacti.conf.erb'
  owner 'root'
  group 'root'
  mode 00644
  notifies :reload, 'service[apache2]', :delayed
end

web_app 'cacti' do
  server_name node['cacti']['apache2']['server_name']
  server_aliases node['cacti']['apache2']['server_aliases']
  doc_root node['cacti']['apache2']['doc_root']
  ssl_enabled node['cacti']['apache2']['ssl']['enabled']
  ssl_forced node['cacti']['apache2']['ssl']['force']
  ssl_certificate_file node['cacti']['apache2']['ssl']['certificate_file']
  ssl_chain_file node['cacti']['apache2']['ssl']['chain_file']
  ssl_key_file node['cacti']['apache2']['ssl']['key_file']
end
