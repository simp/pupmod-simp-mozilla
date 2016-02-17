require 'spec_helper_acceptance'

test_name 'firefox class'

describe 'mozilla::firefox' do

  let(:manifest) {
    <<-EOS
      include 'mozilla::firefox'
    EOS
  }

# We need this for our tests to run properly!
  on 'client', puppet('config set stringify_facts false')

  context 'with defaults' do

## Using puppet_apply as helper
  it 'should work with no errors' do
    apply_manifest(manifest, :catch_failures => true)
  end

  it 'should be idempotent' do
    apply_manifest(manifest, :catch_changes => true)
  end

  describe package('firefox.x86_64') do
    it { is_expected.to be_installed }
  end
  end
end
