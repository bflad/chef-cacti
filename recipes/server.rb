# Install Cacti and dependencies
include_recipe 'mysql::client'

if node['platform'] == 'ubuntu'
  %w{ cacti libsnmp-base libsnmp15 snmp snmpd libnet-ldap-perl libnet-snmp-perl php-net-ldap php5-mysql php-apc php5-snmp }.each do |p|
    package p
  end
else
  %w{ cacti net-snmp net-snmp-utils perl-LDAP perl-Net-SNMP php-ldap php-mysql php-pecl-apc php-snmp }.each do |p|
    package p
  end
end
