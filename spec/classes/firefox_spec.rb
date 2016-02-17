require 'spec_helper'

describe 'mozilla::firefox' do

  let(:facts) {{ :hardwaremodel => 'x86_64' }}

  it { is_expected.to create_class('mozilla::firefox') }
  it { is_expected.to contain_package('firefox.x86_64') }
end
