require 'spec_helper'

describe 'mozilla::thunderbird' do
  on_supported_os.each do |os, os_facts|
    let(:facts) { os_facts }

    context "on #{os}" do
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to create_class('mozilla::thunderbird') }
      it { is_expected.to contain_package('thunderbird') }
    end
  end
end
