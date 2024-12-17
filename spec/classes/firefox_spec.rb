require 'spec_helper'

describe 'mozilla::firefox' do
  on_supported_os.each do |os, os_facts|
    let(:facts) { os_facts }

    context "on #{os}" do
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to create_class('mozilla::firefox') }
      it { is_expected.to contain_package('firefox') }
    end
  end
end
