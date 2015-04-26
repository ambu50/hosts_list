require 'spec_helper'
describe 'hosts_list' do

  context 'with defaults for all parameters' do
    it { should contain_class('hosts_list') }
  end
end
