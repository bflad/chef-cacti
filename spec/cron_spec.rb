require 'spec_helper'

describe 'cacti::cron' do
  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end
end
