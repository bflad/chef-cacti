# chef-cacti [![Build Status](https://secure.travis-ci.org/bflad/chef-cacti.png?branch=master)](http://travis-ci.org/bflad/chef-cacti)

## Description

Install/configures Cacti and optionally Spine.

## Requirements

### Chef

* Chef 11 (for 0.3.0+ of cookbook)

### Platforms

* CentOS 6
* Fedora 19, 20
* PLD Linux Th (Experimental)
* Red Hat Enterprise Linux 6

### Databases

* MySQL

### Cookbooks

* apache2
* apt
* build-essentials
* cron
* database
* mysql
* yum-epel

## Attributes

These attributes are under the `node['cacti']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
cacti_dir | Directory for Cacti installation | String | /usr/share/cacti
cron_minute | Schedule to pass to cron | String | */5
db_file | Database configuration file for Cacti | String | auto-detected (see attributes/default.rb)
group | Group to own Cacti files | String | apache2
packages | Packages for Cacti installation | Array | auto-detected (see attributes/default.rb)
poller_cmd | Poller command to run | String | auto-detected (see attributes/default.rb)
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
description | The name that will be displayed by Cacti in the graphs | String | nil
ip | Self explanatory (can also be a FQDN) | String | nil
template | Specify Host Template: default Graph Templates and Data Queries will associated with the Host | String | nil
notes | Optional general information about this host | String | nil
disable | Add this host but to disable checks | Boolean | false
avail | Method used by Cacti to determine if a host is available for polling (`none`, `ping`, `snmp`, `pingsnmp`) | String | pingsnmp
ping_method | Ping method if avail uses ping (`icmp`, `tcp`, `udp`). NOTE: ICMP on Linux/UNIX requires root privileges. | String | tcp
ping_port | TCP or UDP port to attempt connection (1-65534) | Integer | nil
ping_retries | After an initial failure, the number of ping retries Cacti will attempt before failing | Integer | 2
community | SNMP community string for SNMP v1 and SNMP v2 | String | nil
version | SNMP version when avail check uses SNMP (`1`, `2`, `3`) | Integer | 1
port | UDP port number to use for SNMP | Integer | 161
timeout | The maximum number of milliseconds Cacti will wait for an SNMP response | Integer | 500
max_oids | Number of OIDs that can be obtained in a single SNMP Get request (1-60) | String | 10
username | SNMP username for SNMP v3 | String | nil
password | SNMP password for SNMP v3 | String | nil
authproto | SNMP authentication protocol for SNMP v3 | String | nil
privpass | SNMP privacy passphrase for SNMP v3 | String | nil
privproto | SNMP privacy protocol for SNMP v3 | String | nil
context | SNMP context for SNMP v3 | String | nil

### cacti_graph

Only action supported is `:create`, which is the default.

Attribute | Description | Type | Default
----------|-------------|------|--------
graph_template_id | Graph Template to apply to this graph | String | nil
host_id | The Host that this graph belongs to | String | nil
graph_type | `cg` graphs are for things like CPU temp/fan speed, while `ds` graphs are for data-source based graphs (interface stats etc.) | String | cg
graph_title | Graph Title. If unspecified, defaults to what ever is in the graph template/data-source template | String | nil
input_fields | Input Fields for `cg` type graphs | Hash | nil
snmp_query_id | `ds` graph: name of data query | String | nil
snmp_query_type_id | `ds` graph: SNMP Query Type ID | String | nil
snmp_field | `ds` graph: SNMP Field | String | nil
snmp_value |`ds` graph: SNMP Value | String | nil
reindex_method | `ds` graph: The reindex method to be used for that data query. `None` = no reindexing, `Uptime` = Uptime goes Backwards, `Index`  = Index Count Changed, `Fields` = Verify all Fields | String | None

### cacti_tree

Only action supported is `:create`, which is the default.

Attribute | Description | Type | Default
----------|-------------|------|--------
name | A useful name for the graph tree. | String | nil
type | Type: One of `tree` or `node` | String | nil
sort_method | Tree sort order (`manual`, `alpha`, `natural`, `numeric`) | String | nil
node_type | Node type (`header`, `host`, `graph`) | String | nil
tree_id | Node option | String | nil
parent_node | Choose the parent for the header/graph. | String | nil
host_id | Host node: Choose a host to add it to the tree | String | nil
host_group_style | Host node: How graphs are grouped when drawn for this particular host on the tree (`Graph Template`, `Data Query Index`) | String | nil
graph_id | Graph node: Choose a graph to add it to the tree | String | nil
rra_id | Graph node: Choose a round robin archive to control how Graph Thumbnails are displayed when using Tree Export | String | nil

### cacti_data_query

Only action supported is `:create`, which is the default.

Attribute | Description | Type | Default
----------|-------------|------|--------
host_id | The Host to what to add Data Query | String | nil
data\_query\_id | Data Query to be added | String | nil
reindex_method | The reindex method to be used for that data query. `None` = no reindexing, `Uptime` = Uptime goes Backwards, `Index`  = Index Count Changed, `Fields` = Verify all Fields | String | None

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
