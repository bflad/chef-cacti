cron_d 'cacti' do
  minute node['cacti']['cron_minute']
  command node['cacti']['poller_cmd']
  user node['cacti']['user']
end
