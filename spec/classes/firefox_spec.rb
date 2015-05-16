require 'spec_helper'

describe 'mozilla::firefox' do

  let(:facts) {{ :hardwaremodel => 'x86_64' }}

  it { should create_class('mozilla::firefox') }
  it { should contain_package('firefox.x86_64') }
end
