require File.expand_path('../support/helpers', __FILE__)

describe_recipe 'cacti::cron' do
  include Helpers::CactiCookbook
end
