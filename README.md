# chef-cacti [![Build Status](https://secure.travis-ci.org/bflad/chef-cacti.png?branch=master)](http://travis-ci.org/bflad/chef-cacti)

## Description

Install/configures Cacti and optionally Spine.

## Requirements

### Chef

* Chef 11 (for 0.3.0+ of cookbook)

### Platforms

* CentOS 6
* Fedora 19, 20
* Red Hat Enterprise Linux 6
* Ubuntu 12.04, 12.10, 13.04, 13.10

### Databases

* MySQL

### Cookbooks

[Opscode Cookbooks](https://github.com/opscode-cookbooks/)

* [apache2](https://github.com/opscode-cookbooks/apache2/)
* [apt](https://github.com/opscode-cookbooks/apt/)
* [build-essentials](https://github.com/opscode-cookbooks/build-essentials/)
* [cron](https://github.com/opscode-cookbooks/cron/)
* [database](https://github.com/opscode-cookbooks/database/)
* [mysql](https://github.com/opscode-cookbooks/mysql/)
* [yum-epel](https://github.com/opscode-cookbooks/yum-epel/)

## Attributes

These attributes are under the `node['cacti']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
cacti_dir | Directory for Cacti installation | String | /usr/share/cacti
cron_minute | Schedule to pass to cron | String | */5
db_file | Database configuration file for Cacti | String | auto-detected (see attributes/default.rb)
group | Group to own Cacti files | String | apache2
packages | Packages for Cacti installation | Array | auto-detected (see attributes/default.rb)
poller_file | Poller file for Cacti | String | auto-detected (see attributes/default.rb)
user | Username to own Cacti files | String | cacti
version | Version of Cacti to install or installed | String | auto-detected (see attributes/default.rb)

### Admin Attributes ###

These attributes are under the `node['cacti']['admin']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
password | Local administrator password | String | changeit

### Apache2 Attributes ###

These attributes are under the `node['cacti']['apache2']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
conf_dir | Apache configuration dir | String | /etc/httpd/conf.d
doc_root | VirtualHost DocumentRoot | String | /var/www/html
server_aliases | VirtualHost ServerAliases | Array of Strings | `[ node['hostname'] ]`
server_name | VirtualHost ServerName | String | `node['fqdn']`

These attributes are under the `node['cacti']['apache2']['ssl']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
certificate_file | mod_ssl CertificateFile | String | /etc/pki/tls/certs/localhost.crt
chain_file | mod_ssl CertificateChainFile | String | ""
enabled | Support HTTPS | Boolean | true
force | Force HTTPS | Boolean | false
key_file | mod_ssl CertificateKeyFile | String | /etc/pki/tls/private/localhost.key

### Database Attributes

All of these `node['cacti']['database']` attributes are overridden by `cacti/server` encrypted data bag (Hosted Chef) or data bag (Chef Solo), if it exists

Attribute | Description | Type | Default
----------|-------------|------|--------
host | FQDN or "localhost" (localhost automatically installs `['database']['type']` server) | String | localhost
name | Cacti database name | String | cacti
password | Cacti database user password | String | changeit
port | Cacti database port | Fixnum | 3306
type | Cacti database type - "mysql" only | String | mysql
user | Cacti database user | String | cacti

### rrdtool Attributes

These attributes are under the `node['cacti']['rrdtool']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
version | major.minor version of rrdtool installed - "1.3" or "1.4" | String | auto-detected (see attributes/default.rb)

### Spine Attributes ###

These attributes are under the `node['cacti']['spine']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
checksum | Checksum for Spine | String | auto-detected (see attributes/default.rb)
packages | Packages for Spine installation | Array | auto-detected (see attributes/default.rb)
url | URL for Spine installation | String | `http://www.cacti.net/downloads/spine/cacti-spine-#{node['cacti']['spine']['version']}.tar.gz`
version | Version of Spine to install | String | `node['cacti']['version']`

## Recipes

* `recipe[cacti]` Installs/configures Cacti
* `recipe[cacti::apache2]` Installs/configures Apache 2 and PHP for Cacti
* `recipe[cacti::configuration]` Configures Cacti configuration files
* `recipe[cacti::cron]` Installs Cacti polling cron entry
* `recipe[cacti::database]` Installs/configures Cacti MySQL server
* `recipe[cacti::package]` Installs Cacti via packages
* `recipe[cacti::spine]` Install Spine for Cacti

## LWRPs

* cacti_device: Creating Devices
* cacti_graph: Creating Draphs
* cacti_tree: Adding entries to Tree
* cacti_data_query: Adding data_queries to a Device

Currently only Creating and Adding is supported.

See full documentation for each LWRP and action below for more information.

### cacti_device

Only action supported is `:create`, which is the default.

Attribute | Description | Type | Default
----------|-------------|------|--------
description | the name that will be displayed by Cacti in the graphs | String | nil
ip | self explanatory (can also be a FQDN) | String | nil
template | Host Template | String | nil
notes | General information about this host | String | nil
disable | Add this host but to disable checks | Boolean | false
avail | Method used by Cacti to determine if a host is available for polling (`none`, `ping`, `snmp`, `pingsnmp`) | String | 'ping'
ping_method | Ping method if avail uses ping (`icmp`, `tcp`, `udp`) | String | tcp
ping_port | Ping port (1-65534) | Integer | nil
ping_retries | Number of times to attempt to communicate with a host | Integer | 2
version | SNMP version when avail check uses SNMP (1, 2, 3) | Integer | 1
port | SNMP port | Integer | 161
timeout | SNMP timeout | Integer | 500
username | SNMP username for SNMP v3 | String | nil
password | SNMP password for SNMP v3 | String | nil
authproto | SNMP authentication protocol for SNMP v3 | String | nil
privpass | SNMP privacy passphrase for SNMP v3 | String | nil
privproto | SNMP privacy protocol for SNMP v3 | String | nil
context | SNMP context for SNMP v3 | String | nil
max_oids | Number of OIDs that can be obtained in a single SNMP Get request (1-60) | String | 10

### cacti_graph

Only action supported is `:create`, which is the default.

### cacti_tree

Only action supported is `:create`, which is the default.

### cacti_data_query

Only action supported is `:create`, which is the default.

## Usage

### Cacti Server Data Bag

For securely overriding attributes on Hosted Chef, create a `cacti/server` encrypted data bag with the model below. Chef Solo can override the same attributes with a `cacti/server` unencrypted data bag of the same information.

_required:_
* `['admin']['password']` - local administrator password
* `['database']['host']` - FQDN or "localhost" (localhost automatically installs/configures database)
* `['database']['name']` - Name of Cacti database
* `['database']['user']` - Cacti database username
* `['database']['password']` - Cacti database username password

_optional:_
* `['database']['port']` - Database port, defaults to 3306

Repeat for other Chef environments as necessary. Example:

    {
      "id": "server",
      "development": {
        "admin": {
          "password": "cacti_admin_password"
        },
        "database": {
          "host": "localhost",
          "name": "cacti",
          "user": "cacti",
          "password": "cacti_db_password"
        }
      }
    }

### Cacti Default Installation

* Create recommended (encrypted) data bag: `knife data bag create cacti server --secret-file=path/to/secret`
* Add `recipe[cacti]` to your node's run list.
* Browse to http://`node['cacti']['apache2']['server_name']`/cacti

### Cacti Spine Installation ###

* Add `recipe[cacti::spine]` to your node's run list.
  * If non-localhost database:
    * Login as administrator
    * Settings > Paths > Spine Poller File Path: /usr/bin/spine
    * Settings > Poller > Poller Type: spine

## Testing and Development

Here's how you can quickly get testing or developing against the cookbook thanks to [Vagrant](http://vagrantup.com/) and [Berkshelf](http://berkshelf.com/).

    vagrant plugin install vagrant-berkshelf
    vagrant plugin install vagrant-cachier
    vagrant plugin install vagrant-omnibus
    git clone git://github.com/bflad/chef-cacti.git
    cd chef-cacti
    vagrant up BOX # BOX being centos5, centos6, debian7, fedora18, fedora19, fedora20, freebsd9, ubuntu1204, ubuntu1210, ubuntu1304, or ubuntu1310

You can then SSH into the running VM using the `vagrant ssh BOX` command.

The VM can easily be stopped and deleted with the `vagrant destroy` command. Please see the official [Vagrant documentation](http://docs.vagrantup.com/v2/cli/index.html) for a more in depth explanation of available commands.

## Contributing

Please use standard Github issues/pull requests.

## Contributors

* Brian Flad (<bflad417@gmail.com>)
* Morgan Blackthorne ([@stormerider][])
* Elan Ruusamäe ([@glensc][])

[@glensc]: https://github.com/glensc
[@stormerider]: https://github.com/stormerider
