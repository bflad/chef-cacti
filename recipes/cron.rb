cron_d 'cacti' do
  minute node['cacti']['cron_minute']
  command "/usr/bin/php #{node['cacti']['poller_file']} > /dev/null 2>&1"
  user node['cacti']['user']
end
