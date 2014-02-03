require File.expand_path('../support/helpers', __FILE__)

describe_recipe 'cacti::apache2' do
  include Helpers::CactiCookbook
end
