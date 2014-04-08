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
