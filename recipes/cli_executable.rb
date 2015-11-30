node['cacti']['cli_scripts'].each do |script|
  file "#{node['cacti']['cacti_dir']}/cli/#{script}" do
    mode '0755'
  end
end
