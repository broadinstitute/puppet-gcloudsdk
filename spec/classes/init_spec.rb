require 'spec_helper'

describe 'gcloudsdk' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it do
        is_expected.to compile.with_all_deps
      end
    end
  end
end
