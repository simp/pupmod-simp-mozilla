require 'spec_helper_acceptance'

test_name 'firefox class'

describe 'mozilla::firefox' do
  let(:manifest) do
    <<-EOS
      include 'mozilla::firefox'
    EOS
  end

  context 'with defaults' do
    it 'works with no errors' do
      apply_manifest(manifest, catch_failures: true)
    end

    it 'is idempotent' do
      apply_manifest(manifest, catch_changes: true)
    end

    describe package('firefox') do
      it { is_expected.to be_installed }
    end
  end
end
