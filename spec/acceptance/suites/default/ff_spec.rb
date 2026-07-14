require 'spec_helper_acceptance'

test_name 'firefox class'

describe 'mozilla::firefox' do
  let(:manifest) do
    <<-EOS
      include 'mozilla::firefox'
    EOS
  end

  # Exercise noop from a clean (uninstalled) state: on a fresh node the Sicura
  # console previews the module with `puppet apply --noop`, which must not error
  # even though nothing mozilla manages exists yet. Real idempotence is covered
  # by the applies below. A post-convergence noop check is deliberately omitted:
  # `puppet apply --noop --detailed-exitcodes` always exits 0, so it could never
  # fail and would test nothing.
  context 'in noop mode from a clean state' do
    before(:context) do
      on(hosts, 'puppet resource package firefox ensure=absent')
    end

    it 'applies without errors in noop mode' do
      apply_manifest(manifest, catch_failures: true, noop: true)
    end
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
