require 'spec_helper'

describe 'mozilla::firefox' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
   
      let(:facts) do
        facts
      end

  context "on #{os}"do
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to create_class('mozilla::firefox') }

      context 'base' do
        it { should contain_package('firefox.x86_64').with(:ensure =>'latest') }
      end
    end
   end
  end
end
