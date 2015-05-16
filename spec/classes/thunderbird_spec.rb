require 'spec_helper'

describe 'mozilla::thunderbird' do

  let(:facts) {{ :hardwaremodel => 'x86_64' }}

  it { should create_class('mozilla::thunderbird') }
  it { should contain_package('thunderbird.x86_64') }
end
