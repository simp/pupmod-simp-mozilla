require 'spec_helper'

describe 'mozilla::thunderbird' do
  context 'supported operating system' do
    on_supported_os.each do |os, facts|
      let(:facts) {{ :hardwaremodel => 'x86_64' }}

  context "on #{os}" do
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to create_class('mozilla::thunderbird') }

    context 'base'do
      it { is_expected.to contain_package('thunderbird.x86_64').with(:ensure =>'latest') }
    end
   end
  end
 end
end

