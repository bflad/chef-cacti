default['cacti']['version']     = '0.8.8a'
default['cacti']['user']        = 'cacti'
default['cacti']['group']       = 'apache'
default['cacti']['cron_minute'] = '*/5'

# Apache2 attributes

default['cacti']['apache2']['server_name']             = node['fqdn']
default['cacti']['apache2']['server_aliases']          = [node['hostname']]
default['cacti']['apache2']['conf_dir']                = '/etc/httpd/conf.d'
default['cacti']['apache2']['doc_root']                = '/var/www/html'

default['cacti']['apache2']['ssl']['certificate_file'] = '/etc/pki/tls/certs/localhost.crt'
default['cacti']['apache2']['ssl']['chain_file']       = ''
default['cacti']['apache2']['ssl']['force']            = false
default['cacti']['apache2']['ssl']['enabled']          = true
default['cacti']['apache2']['ssl']['key_file']         = '/etc/pki/tls/private/localhost.key'

# Spine attributes

default['cacti']['spine']['version']  = node['cacti']['version']
default['cacti']['spine']['url']      = "http://www.cacti.net/downloads/spine/cacti-spine-#{node['cacti']['spine']['version']}.tar.gz"
default['cacti']['spine']['checksum'] = '2226070cd386a4955063a87e99df2fa861988a604a95f39bb8db2a301774b3ee'
