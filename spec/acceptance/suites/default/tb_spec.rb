require 'spec_helper_acceptance'

test_name 'thunderbird class'

describe 'mozilla::thunderbird' do
  let(:manifest) do
    <<-EOS
    include 'mozilla::thunderbird'
    EOS
  end

  context 'with defaults' do
    it 'works with no errors' do
      apply_manifest(manifest, catch_failures: true)
    end

    it 'is idempotent' do
      apply_manifest(manifest, catch_changes: true)
    end

    describe package('thunderbird') do
      it { is_expected.to be_installed }
    end
  end
end
