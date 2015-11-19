include_recipe 'apache2'
include_recipe 'apache2::mpm_prefork'
include_recipe 'apache2::mod_php5'
include_recipe 'apache2::mod_rewrite'
#include_recipe 'apache2::mod_ssl'

# log "Creating a self signed certificate"
# directory default['cacti']['apache2']['ssl']['certificate_directory'] do
#     owner "root"
#     group "root"
#     mode 0755
#     action :create
#     recursive true
# end

# log "Running : openssl genrsa -passout pass:#{node[:selfsigned_certificate][:sslpassphrase]} -des3 -out server.key 1024"
# bash "generate certificate" do
#   user "root"
#   cwd node['selfsigned_certificate']['destination']
#   code <<-EOH
#         openssl genrsa -passout pass:#{node[:selfsigned_certificate][:sslpassphrase]} -des3 -out server.key 1024
#         EOH
# end

# log "Running : openssl req -passin pass:#{node[:selfsigned_certificate][:sslpassphrase]} -subj \"/C=#{node[:selfsigned_certificate][:country]}/ST=#{node[:selfsigned_certificate][:state]}/L=#{node[:selfsigned_certificate][:city]}/O=#{node[:selfsigned_certificate][:orga]}/OU=#{node[:selfsigned_certificate][:depart]}/CN=#{node[:selfsigned_certificate][:cn]}/emailAddress=#{node[:selfsigned_certificate][:email]}\" -new -key server.key -out server.csr"
# bash "generate signature request" do
#   user "root"
#   cwd node['selfsigned_certificate']['destination']
#   code <<-EOH
#         openssl req -passin pass:#{node[:selfsigned_certificate][:sslpassphrase]} -subj "/C=#{node[:selfsigned_certificate][:country]}/ST=#{node[:selfsigned_certificate][:state]}/L=#{node[:selfsigned_certificate][:city]}/O=#{node[:selfsigned_certificate][:orga]}/OU=#{node[:selfsigned_certificate][:depart]}/CN=#{node[:selfsigned_certificate][:cn]}/emailAddress=#{node[:selfsigned_certificate][:email]}" -new -key server.key -out server.csr
#         EOH
# end

# log "Running: openssl rsa -passin pass:#{node[:selfsigned_certificate][:sslpassphrase]} -in server.key.org -out server.key"
# bash "sign key" do
#   user "root"
#   cwd node['selfsigned_certificate']['destination']
#   code <<-EOH
#         cp server.key server.key.org
#         openssl rsa -passin pass:#{node[:selfsigned_certificate][:sslpassphrase]} -in server.key.org -out server.key
#         EOH
# end

# log "Running: openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt"
# bash "signing the certificate" do
#   user "root"
#   cwd node['selfsigned_certificate']['destination']
#   code <<-EOH
#         openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
#         EOH
# end

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
