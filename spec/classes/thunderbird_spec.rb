require 'spec_helper'

describe 'mozilla::thunderbird' do

  let(:facts) {{ :hardwaremodel => 'x86_64' }}

  it { is_expected.to create_class('mozilla::thunderbird') }
  it { is_expected.to contain_package('thunderbird.x86_64') }
end
