require 'spec_helper'

describe 'cacti::configuration' do
  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end
end
