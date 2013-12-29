default['cacti']['version']     = '0.8.8a'
default['cacti']['user']        = 'cacti'
default['cacti']['group']       = 'apache'
default['cacti']['cron_minute'] = '*/5'
default['cacti']['db_file'] =
  case node['platform_family']
  when 'debian'; '/etc/cacti/debian.php'
  when 'fedora', 'rhel'; '/etc/cacti/db.php'
  end
default['cacti']['packages'] = value_for_platform(
  %w{ centos redhat } => {
    'default' => %w{ cacti net-snmp net-snmp-utils perl-LDAP perl-Net-SNMP php-ldap php-mysql php-pecl-apc php-snmp }
  },
  %w{ ubuntu } => {
    %w{ 12.04 12.10 13.04 } => %w{ cacti libsnmp-base libsnmp15 snmp snmpd libnet-ldap-perl libnet-snmp-perl php-net-ldap php5-mysql php-apc php5-snmp },
    '13.10' => %w{ cacti libsnmp-base libsnmp30 snmp snmpd libnet-ldap-perl libnet-snmp-perl php-net-ldap php5-mysql php-apc php5-snmp },
    'default' => %w{ cacti libsnmp-base libsnmp15 snmp snmpd libnet-ldap-perl libnet-snmp-perl php-net-ldap php5-mysql php-apc php5-snmp }
  }
)
default['cacti']['poller_file'] =
  case node['platform_family']
  when 'debian'; '/usr/share/cacti/site/poller.php'
  when 'fedora', 'rhel'; '/usr/share/cacti/poller.php'
  end

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
default['cacti']['spine']['packages'] = value_for_platform(
  %w{ centos redhat } => {
    'default' => %w{ net-snmp-devel openssl-devel }
  },
  %w{ ubuntu } => {
    'default' => %w{ libsnmp-dev libssl-dev }
  }
)
