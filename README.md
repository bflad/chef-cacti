# chef-cacti [![Build Status](https://secure.travis-ci.org/bflad/chef-cacti.png?branch=master)](http://travis-ci.org/bflad/chef-cacti)

## Description

Install/configures Cacti server.

## Requirements

### Platforms

* RedHat 6.3 (Santiago)

### Databases

* MySQL

### Cookbooks

Opscode Cookbooks (http://github.com/opscode-cookbooks/)

* apache2
* build-essentials
* cron
* database
* mysql

## Attributes

* `node['cacti']['version']` - Version of Cacti to install, defaults to "0.8.8a" but currently is dependent on package available

### Apache2 Attributes ###

* `node['cacti']['apache2']['server_name']` - VirtualHost ServerName, defaults to `node['fqdn']`
* `node['cacti']['apache2']['server_aliases']` - VirtualHost ServerAlias array, defaults to `[ node['hostname'] ]`
* `node['cacti']['apache2']['ssl']['certificate_file']` - mod_ssl CertificateFile, defaults to "/etc/pki/tls/certs/localhost.crt"
* `node['cacti']['apache2']['ssl']['chain_file']` - mod_ssl CertificateChainFile, defaults to ""
* `node['cacti']['apache2']['ssl']['force']` - force HTTPS, defaults to false
* `node['cacti']['apache2']['ssl']['key_file']` - mod_ssl CertificateKeyFile, defaults to "/etc/pki/tls/private/localhost.key"

### Spine Attributes ###

* `node['cacti']['spine']['checksum']` - Checksum for version of Spine to install.
* `node['cacti']['spine']['url']` - URL for Spine installation
* `node['cacti']['spine']['version']` - Version of Spine to install, defaults to `node['cacti']['version']`

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

## License and Author
      
Author:: Brian Flad (<bflad@wharton.upenn.edu>)

Copyright:: 2013

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
