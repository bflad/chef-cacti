# chef-cacti [![Build Status](https://secure.travis-ci.org/bflad/chef-cacti.png?branch=master)](http://travis-ci.org/bflad/chef-cacti)

## Description

Install/configures Cacti server.

## Requirements

### Platforms

* CentOS 6
* Red Hat Enterprise Linux 6
* Ubuntu 12.04

### Databases

* MySQL

### Cookbooks

[Opscode Cookbooks](https://github.com/opscode-cookbooks/)

* [apache2](https://github.com/opscode-cookbooks/apache2/)
* [build-essentials](https://github.com/opscode-cookbooks/build-essentials/)
* [cron](https://github.com/opscode-cookbooks/cron/)
* [database](https://github.com/opscode-cookbooks/database/)
* [mysql](https://github.com/opscode-cookbooks/mysql/)

## Attributes

These attributes are under the `node['cacti']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
version | Version of Cacti to install | String | "0.8.8a", but currently is dependent on package available
user | Username to own Cacti files | String | `cacti`
group | Group to own Cacti files | String | `apache2`
cron_minute | Schedule to pass to cron | String | "*/5"

### Apache2 Attributes ###

These attributes are under the `node['cacti']['apache2']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
server_aliases | VirtualHost ServerAliases | Array of Strings | `[ node['hostname'] ]`
server_name | VirtualHost ServerName | String | `node['fqdn']`
conf_dir | Apache configuration dir | String | '/etc/httpd/conf.d'
doc_root | VirtualHost DocumentRoot | String | `/var/www/html`

These attributes are under the `node['cacti']['apache2']['ssl']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
certificate_file | mod_ssl CertificateFile | String | /etc/pki/tls/certs/localhost.crt
chain_file | mod_ssl CertificateChainFile | String | ""
force | Force HTTPS | Boolean | false
key_file | mod_ssl CertificateKeyFile | String | /etc/pki/tls/private/localhost.key
enabled | Support HTTPS | Boolean | true

### Spine Attributes ###

These attributes are under the `node['cacti']['spine']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
checksum | Checksum for Spine | String | -
url | URL for Spine installation | String | 
version | Version of Spine to install | String | `node['cacti']['version']`

## Recipes

* `recipe[cacti]` empty recipe.
* `recipe[cacti::server]` will install Cacti server.
* `recipe[cacti::spine]` will install Spine for Cacti server.

## Usage

### Cacti Server Required Data Bag

Create a cacti/server encrypted data bag with the following information per Chef environment:

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

### Cacti Server Installation

* Create required encrypted data bag: `knife data bag create cacti server --secret-file=path/to/secret`
* Add `recipe[cacti::server]` to your node's run list.
* Browse to http://`node['cacti']['apache2']['server_name']`/cacti

### Cacti Spine Installation ###

* Add `recipe[cacti::spine]` to your node's run list.
  * If non-localhost database:
    * Login as administrator
    * Settings > Paths > Spine Poller File Path: /usr/bin/spine
    * Settings > Poller > Poller Type: spine

## Contributing

Please use standard Github issues/pull requests.

## Contributors

* Brian Flad (<bflad417@gmail.com>)
* Morgan Blackthorne (@stormerider)
