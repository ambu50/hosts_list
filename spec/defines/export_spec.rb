# frozen_string_literal: true

require 'spec_helper'

describe 'hosts_list::export' do
  let(:title) { 'namevar' }
  let(:params) do
    {
      'directory' => '/tmp'
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
