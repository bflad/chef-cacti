# Chef class
class Chef
  # Chef::Recipe class
  class Recipe
    # Chef::Recipe::Cacti class
    class Cacti
      def self.settings(node)
        begin
          if Chef::Config[:solo]
            begin
              settings = Chef::DataBagItem.load('cacti', 'server')['local']
            rescue
              Chef::Log.info('No cacti/server data bag found')
            end
          else
            begin
              settings = Chef::EncryptedDataBagItem.load('cacti', 'server')[node.chef_environment]
            rescue
              Chef::Log.info('No cacti/server encrypted data bag found')
            end
          end
        ensure
          settings ||= node['cacti']
          settings['database']['port'] ||= default_database_port settings['database']['type']
        end

        settings
      end

      def self.spine_checksum(node)
        return node['cacti']['spine']['checksum'] if node['cacti']['spine']['checksum']
        case node['cacti']['version']
        when '0.8.7i'; '94596d8f083666e5c9be12cc364418e31654b8ff29b6837b305009adcad91c6b'
        when '0.8.8a'; '2226070cd386a4955063a87e99df2fa861988a604a95f39bb8db2a301774b3ee'
        when '0.8.8b'; 'fc5d512c1de46db2b48422856e8c6a5816d110083d0bbbf7f9d660f0829912a6'
        else
          Chef::Log.warn("No checksum found for spine version: #{node['cacti']['version']}")
          Chef::Log.warn('Please add to Cacti cookbook or set node["cacti"]["spine"]["checksum"] attribute.')
          nil
        end
      end

      def self.spine_url(node)
        return node['cacti']['spine']['url'] if node['cacti']['spine']['url']
        "http://www.cacti.net/downloads/spine/cacti-spine-#{node['cacti']['version']}.tar.gz"
      end

      def self.sql_dir(node)
        return node['cacti']['sql_dir'] if node['cacti']['sql_dir']
        node.value_for_platform(
          %w(debian ubuntu) => {
            'default' => '/usr/share/doc/cacti'
          },
          %w(pld) => {
            'default' => '/usr/share/cacti/sql'
          },
          %w(centos fedora redhat) => {
            'default' => "/usr/share/doc/cacti-#{node['cacti']['version']}"
          }
        )
      end

      def default_database_port(type)
        case type
        when 'mysql'
          3306
        else
          Chef::Log.warn("Unsupported database type (#{type}) in Cacti cookbook.")
          Chef::Log.warn('Please add to Cacti cookbook or hard set Cacti database port.')
          nil
        end
      end
    end
  end
end
