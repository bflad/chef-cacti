default['cacti']['cacti_dir'] = '/usr/share/cacti'
default['cacti']['cli_scripts'] = %w(
  add_data_query.php
  add_device.php
  add_graphs.php
  add_graph_template.php
  add_perms.php
  add_tree.php
  analyze_database.php
  convert_innodb.php
  copy_user.php
  data_template_associate_rra.php
  host_update_template.php
  import_template.php
  poller_data_sources_reapply_names.php
  poller_graphs_reapply_names.php
  poller_output_empty.php
  poller_reindex_hosts.php
  rebuild_poller_cache.php
  reorder_data_query.php
  repair_database.php
  repair_templates.php
  structure_rra_paths.php
  upgrade_database.php
  )
default['cacti']['cron_minute'] = '*/5'
default['cacti']['db_file'] = value_for_platform(
  %w(centos fedora redhat) => {
    'default' => '/etc/cacti/db.php'
  },
  %w(pld) => {
    'default' => '/etc/webapps/cacti/config.php'
  },
  %w(debian ubuntu) => {
    'default' => '/etc/cacti/debian.php'
  }
)
default['cacti']['gid'] = nil
default['cacti']['group'] = value_for_platform(
  %w(pld) => {
    'default' => 'http'
  },
  %w(centos fedora redhat) => {
    'default' => 'apache'
  },
  %w(debian ubuntu) => {
    'default' => 'www-data'
  }
)

default['cacti']['log_file'] = value_for_platform(
  %w(pld) => {
    'default' => '/var/log/cacti/cacti.log'
  },
  %w(centos debian fedora redhat ubuntu) => {
    'default' => '/usr/share/cacti/log/cacti.log'
  }
)

default['cacti']['mysql_provider'] = 'mysql'

default['cacti']['packages'] = value_for_platform(
  %w(centos fedora redhat) => {
    'default' => %w(cacti net-snmp net-snmp-utils perl-LDAP perl-Net-SNMP php-ldap php-mysql php-pecl-apc php-snmp)
  },
  %w(debian) => {
    '7' => %w(cacti libsnmp-base libsnmp15 snmp snmpd libnet-ldap-perl libnet-snmp-perl php-net-ldap php5-mysql php-apc php5-snmp),
    'default' => %w(cacti libsnmp-base libsnmp30 snmp snmpd libnet-ldap-perl libnet-snmp-perl php-net-ldap php5-mysql php-apc php5-snmp)
  },
  %w(pld) => {
    'default' => %w(cacti cacti-setup)
  },
  %w(debian ubuntu) => {
    %w(12.04 12.10 13.04) => %w(cacti libsnmp-base libsnmp15 snmp snmpd libnet-ldap-perl libnet-snmp-perl php-net-ldap php5-mysql php-apc php5-snmp),
    'default' => %w(cacti libsnmp-base libsnmp30 snmp snmpd libnet-ldap-perl libnet-snmp-perl php-net-ldap php5-mysql php-apc php5-snmp)
  }
)
default['cacti']['poller_file'] = value_for_platform(
  %w(centos fedora redhat) => {
    'default' => '/usr/share/cacti/poller.php'
  },
  %w(pld) => {
    'default' => '/usr/sbin/cacti-poller'
  },
  %w(debian ubuntu) => {
    'default' => '/usr/share/cacti/site/poller.php'
  }
)
default['cacti']['poller_cmd'] = value_for_platform(
  %w(pld) => {
    'default' => "umask 022; exec #{node['cacti']['poller_file']} >> /var/log/cacti/poller.log 2>&1"
  },
  %w(centos debian fedora redhat ubuntu) => {
    'default' => "/usr/bin/php #{node['cacti']['poller_file']} > /dev/null 2>&1"
  }
)

default['cacti']['sql_dir'] = nil
default['cacti']['uid'] = nil
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
    %w(13.10 14.04 14.10) => '0.8.8b',
    'default' => '0.8.8f'
  },
  %w(debian) => {
    '7' => '0.8.8a',
    '8' => '0.8.8b',
    'default' => '0.8.8f'
  }
)

# admin attributes (override via cacti/server data bag)

default['cacti']['admin']['password'] = 'changeit'

# Apache2 attributes

default['cacti']['apache2']['doc_root'] = '/var/www/html'
default['cacti']['apache2']['server_aliases'] = [node['hostname']]
default['cacti']['apache2']['server_name'] = node['fqdn']

default['cacti']['apache2']['ssl']['certificate_file'] = value_for_platform(
  %w(pld) => {
    'default' => '/etc/httpd/ssl/server.crt'
  },
  %w(centos fedora redhat) => {
    'default' => '/etc/pki/tls/certs/localhost.crt'
  },
  %w(debian ubuntu) => {
    'default' => '/etc/ssl/certs/ssl-cert-snakeoil.pem'
  }
)

default['cacti']['apache2']['ssl']['chain_file'] = ''
default['cacti']['apache2']['ssl']['enabled'] = true
default['cacti']['apache2']['ssl']['force'] = false

default['cacti']['apache2']['ssl']['key_file'] = value_for_platform(
  %w(pld) => {
    'default' => '/etc/httpd/ssl/server.key'
  },
  %w(centos fedora redhat) => {
    'default' => '/etc/pki/tls/private/localhost.key'
  },
  %w(debian ubuntu) => {
    'default' => '/etc/ssl/private/ssl-cert-snakeoil.key'
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
  %w(debian ubuntu) => {
    'default' => '1.4'
  }
)

# Spine attributes

default['cacti']['spine']['checksum'] = nil
default['cacti']['spine']['enabled'] = false
default['cacti']['spine']['packages'] = value_for_platform(
  %w(centos fedora redhat) => {
    'default' => %w(net-snmp-devel openssl-devel)
  },
  %w(pld) => {
    'default' => %w(net-snmp-devel openssl-devel)
  },
  %w(debian ubuntu) => {
    'default' => %w(libsnmp-dev libssl-dev)
  }
)
default['cacti']['spine']['url'] = nil
