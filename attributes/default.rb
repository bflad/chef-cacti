default['cacti']['cron_minute'] = '*/5'
default['cacti']['db_file'] = value_for_platform(
  %w{ centos redhat } => {
    'default' => '/etc/cacti/db.php'
  },
  %w{ ubuntu } => {
    'default' => '/etc/cacti/debian.php'
  }
)
default['cacti']['group'] = 'apache'
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
default['cacti']['poller_file'] = value_for_platform(
  %w{ centos redhat } => {
    'default' => '/usr/share/cacti/poller.php'
  },
  %w{ ubuntu } => {
    'default' => '/usr/share/cacti/site/poller.php'
  }
)
default['cacti']['user'] = 'cacti'
default['cacti']['version'] = value_for_platform(
  %w{ centos redhat } => {
    'default' => '0.8.8b'
  },
  %w{ ubuntu } => {
    '12.04' => '0.8.7i',
    %w{ 12.10 13.04 } => '0.8.8a',
    '13.10' => '0.8.8b',
    'default' => '0.8.8a'
  }
)

# Apache2 attributes

default['cacti']['apache2']['conf_dir'] = '/etc/httpd/conf.d'
default['cacti']['apache2']['doc_root'] = '/var/www/html'
default['cacti']['apache2']['server_aliases'] = [node['hostname']]
default['cacti']['apache2']['server_name'] = node['fqdn']

default['cacti']['apache2']['ssl']['certificate_file'] = '/etc/pki/tls/certs/localhost.crt'
default['cacti']['apache2']['ssl']['chain_file'] = ''
default['cacti']['apache2']['ssl']['enabled'] = true
default['cacti']['apache2']['ssl']['force'] = false
default['cacti']['apache2']['ssl']['key_file'] = '/etc/pki/tls/private/localhost.key'

# rrdtool attributes

default['cacti']['rrdtool']['version'] = value_for_platform(
  %w{ centos redhat } => {
    'default' => '1.3'
  },
  %w{ ubuntu } => {
    'default' => '1.4'
  }
)

# Spine attributes

default['cacti']['spine']['version'] = node['cacti']['version']
default['cacti']['spine']['checksum'] = '2226070cd386a4955063a87e99df2fa861988a604a95f39bb8db2a301774b3ee'
default['cacti']['spine']['packages'] = value_for_platform(
  %w{ centos redhat } => {
    'default' => %w{ net-snmp-devel openssl-devel }
  },
  %w{ ubuntu } => {
    'default' => %w{ libsnmp-dev libssl-dev }
  }
)
default['cacti']['spine']['url'] = "http://www.cacti.net/downloads/spine/cacti-spine-#{node['cacti']['spine']['version']}.tar.gz"
