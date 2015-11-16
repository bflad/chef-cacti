default['cacti']['cacti_dir'] = '/usr/share/cacti'
default['cacti']['cron_minute'] = '*/5'
default['cacti']['db_file'] = value_for_platform(
  %w(centos fedora redhat) => {
    'default' => '/etc/cacti/db.php'
  },
  %w(pld) => {
    'default' => '/etc/webapps/cacti/config.php'
  },
  %w(ubuntu) => {
    'default' => '/etc/cacti/debian.php'
  }
)
default['cacti']['group'] = value_for_platform(
  %w(pld) => {
    'default' => 'http'
  },
  %w(centos fedora redhat) => {
    'default' => 'apache'
  },
  %w(ubuntu debian) => {
    'default' => 'www-data'
  }
)

default['cacti']['packages'] = value_for_platform(
  %w(centos fedora redhat) => {
    'default' => %w(cacti net-snmp net-snmp-utils perl-LDAP perl-Net-SNMP php-ldap php-mysql php-pecl-apc php-snmp)
  },
  %w(pld) => {
    'default' => %w(cacti cacti-setup)
  },
  %w(ubuntu) => {
    %w(12.04 12.10 13.04) => %w(cacti libsnmp-base snmp snmpd libnet-ldap-perl libnet-snmp-perl php-net-ldap php5-mysql php-apc php5-snmp),
    '13.10' => %w(cacti libsnmp-base libsnmp30 snmp snmpd libnet-ldap-perl libnet-snmp-perl php-net-ldap php5-mysql php-apc php5-snmp),
    'default' => %w(cacti libsnmp-base snmp snmpd libnet-ldap-perl libnet-snmp-perl php-net-ldap php5-mysql php-apc php5-snmp)
  }
)
default['cacti']['poller_file'] = value_for_platform(
  %w(centos fedora redhat) => {
    'default' => '/usr/share/cacti/poller.php'
  },
  %w(pld) => {
    'default' => '/usr/sbin/cacti-poller'
  },
  %w(ubuntu) => {
    'default' => '/usr/share/cacti/site/poller.php'
  }
)
default['cacti']['poller_cmd'] = value_for_platform(
  %w(pld) => {
    'default' => "umask 022; exec #{node['cacti']['poller_file']} >> /var/log/cacti/poller.log 2>&1"
  },
  %w(centos fedora redhat ubuntu) => {
    'default' => "/usr/bin/php #{node['cacti']['poller_file']} > /dev/null 2>&1"
  }
)

default['cacti']['user'] = 'cacti'
default['cacti']['version'] = value_for_platform(
  %w(centos fedora redhat) => {
    'default' => '0.8.8b'
  },
  %w(pld) => {
    '2.0' => '0.8.7i',
    'default' => '0.8.8b'
  },
  %w(ubuntu) => {
    '12.04' => '0.8.7i',
    %w(12.10 13.04) => '0.8.8a',
    '13.10' => '0.8.8b',
    'default' => '0.8.8a'
  }
)

# admin attributes (override via cacti/server data bag)

default['cacti']['admin']['password'] = 'changeit'

# Apache2 attributes

default['cacti']['apache2']['conf_dir'] = value_for_platform(
  %w(centos fedora redhat) => {
    'default' => '/etc/httpd/conf.d'
    },
  %w('ubuntu debian') => {
    'default' => '/etc/apache2/conf.d'
  }
)
default['cacti']['apache2']['doc_root'] = '/var/www/html'
default['cacti']['apache2']['server_aliases'] = [node['hostname']]
default['cacti']['apache2']['server_name'] = node['fqdn']

default['cacti']['apache2']['ssl']['certificate_directory'] = value_for_platform(
  %w(pld) => {
    'default' => '/etc/httpd/ssl/'
  },
  %w(centos fedora redhat ubuntu) => {
    'default' => '/etc/pki/tls/certs/'
  }
)

default['cacti']['apache2']['ssl']['certificate_file'] = value_for_platform(
  %w(pld) => {
    'default' => default['cacti']['apache2']['ssl']['certificate_directory'] + 'server.crt'
  },
  %w(centos fedora redhat ubuntu) => {
    'default' => default['cacti']['apache2']['ssl']['certificate_directory'] + 'localhost.crt'
  }
)

default['cacti']['apache2']['ssl']['chain_file'] = ''
default['cacti']['apache2']['ssl']['enabled'] = true
default['cacti']['apache2']['ssl']['force'] = false
default['cacti']['apache2']['ssl']['key_file'] = value_for_platform(
  %w(pld) => {
    'default' => default['cacti']['apache2']['ssl']['certificate_directory'] + 'server.key'
  },
  %w(centos fedora redhat ubuntu) => {
    'default' => default['cacti']['apache2']['ssl']['certificate_directory'] + 'localhost.key'
  }
)

# database attributes (override via cacti/server data bag)

default['cacti']['database']['host'] = '127.0.0.1'
default['cacti']['database']['name'] = 'cacti'
default['cacti']['database']['password'] = 'changeit'
default['cacti']['database']['port'] = 3306
default['cacti']['database']['type'] = 'mysql'
default['cacti']['database']['user'] = 'cacti'

# rrdtool attributes

default['cacti']['rrdtool']['version'] = value_for_platform(
  %w(centos redhat) => {
    'default' => '1.3'
  },
  %w(fedora) => {
    'default' => '1.4'
  },
  %w(pld) => {
    '2.0' => '1.2',
    'default' => '1.4'
  },
  %w(ubuntu) => {
    'default' => '1.4'
  }
)

# Spine attributes

default['cacti']['spine']['version'] = node['cacti']['version']
default['cacti']['spine']['checksum'] = '2226070cd386a4955063a87e99df2fa861988a604a95f39bb8db2a301774b3ee'
default['cacti']['spine']['packages'] = value_for_platform(
  %w(centos fedora redhat) => {
    'default' => %w(net-snmp-devel openssl-devel)
  },
  %w(pld) => {
    'default' => %w(net-snmp-devel openssl-devel)
  },
  %w(ubuntu) => {
    'default' => %w(libsnmp-dev libssl-dev)
  }
)
default['cacti']['spine']['url'] = "http://www.cacti.net/downloads/spine/cacti-spine-#{node['cacti']['spine']['version']}.tar.gz"
