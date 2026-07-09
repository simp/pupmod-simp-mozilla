# AGENTS.md

This file provides guidance to AI agents when working with code in this repository.

## What this module does

`simp-mozilla` is a small SIMP Puppet module that installs Mozilla desktop
products from the OS package repositories. It manages exactly two packages via
two public classes: `mozilla::firefox` installs `firefox`
(`manifests/firefox.pp`) and `mozilla::thunderbird` installs
`thunderbird` (`manifests/thunderbird.pp`). There is no service or config
management — the module is a thin, declarative wrapper around `package`
resources whose ensure state is driven by the SIMP `simp_options::package_ensure`
seam.

The top-level `mozilla` class (`manifests/init.pp`) does nothing except call
`simplib::assert_metadata($module_name)`; both feature classes `include
'mozilla'` so that assertion always runs.

### Business logic

Three classes, no defines. None of them are `assert_private()`'d — all three are
part of the public API and are consumed with `include`.

- **`mozilla` (`manifests/init.pp`)** — Base class. Its entire body is
  `simplib::assert_metadata($module_name)` (`init.pp`), which fails the catalog
  early on an unsupported OS (per `metadata.json` `operatingsystem_support`). No
  parameters, no resources.
- **`mozilla::firefox` (`manifests/firefox.pp`)** — Public class. One
  parameter `$package_ensure` (`String`) defaulting to
  `simplib::lookup('simp_options::package_ensure', { 'default_value' => 'installed' })`
  (`firefox.pp`). `include 'mozilla'` (`firefox.pp`), then
  `package { 'firefox': ensure => $package_ensure }` (`firefox.pp`).
- **`mozilla::thunderbird` (`manifests/thunderbird.pp`)** — Public class.
  Parameters: `$package_ensure` (`String`, same `simp_options::package_ensure`
  default, `thunderbird.pp`) and `$install_options` (`Optional[String]`,
  default `undef`, `thunderbird.pp`). `include 'mozilla'`
  (`thunderbird.pp`), then
  `package { 'thunderbird': ensure => $package_ensure, install_options => $install_options }`
  (`thunderbird.pp`). The `install_options` are passed straight through to
  the package provider (e.g. extra `yum`/`dnf` flags).

### Gotchas / non-obvious details

- **`mozilla` (init.pp) is not a "do everything" entry point.** Unlike many SIMP
  modules, `include 'mozilla'` installs nothing — it only runs
  `simplib::assert_metadata` (`init.pp`). To install software you must include
  `mozilla::firefox` and/or `mozilla::thunderbird` directly.
- **The only shipped Hiera data targets an unsupported OS.** The sole data file
  is `data/os/OracleLinux-7.yaml`, which sets
  `mozilla::thunderbird::install_options: '--enablerepo=ol7_optional_latest'`.
  OracleLinux 7 is **not** in `metadata.json`'s `operatingsystem_support` (which
  lists only EL 8/9/10), so on every currently-supported OS `$install_options`
  falls through to its `undef` default. Treat this file as legacy.
- **No `common.yaml`.** `hiera.yaml` declares a three-level hierarchy
  (`os/<name>-<major>.yaml` → `os/<name>.yaml` → `common.yaml`), but only
  `data/os/OracleLinux-7.yaml` exists; the OS-family and `common.yaml` tiers
  resolve to nothing.
- **`simp/simp_options` is NOT a declared dependency** in `metadata.json`, yet
  both feature classes consume the `simp_options::package_ensure` seam via
  `simplib::lookup` (the function is provided by `simp/simplib`). Unlike some
  SIMP modules, `simp_options` is not even a fixture here — `.fixtures.yml` pulls
  only `simplib` and `stdlib`. The `default_value` in each `simplib::lookup` call
  is what makes the classes compile without it.
- **`assert_metadata` gates the catalog on OS.** Applying any class on an OS
  outside the `metadata.json` matrix fails at compile time via
  `simplib::assert_metadata` (`init.pp`).
- **`puppetlabs/stdlib` is declared but not obviously used** by the manifests
  (no stdlib function calls appear in `manifests/`). It is retained as a standard
  SIMP baseline dependency and as a fixture.

## The `simp_options` / `simplib::lookup` seam

This is the module's only business-logic seam — the ensure state of both
packages. Both calls resolve `simp_options::package_ensure`:

| File | Key | `default_value` |
|------|-----|-----------------|
| `manifests/firefox.pp` | `simp_options::package_ensure` | `'installed'` |
| `manifests/thunderbird.pp` | `simp_options::package_ensure` | `'installed'` |

Keep routing SIMP feature toggles through
`simplib::lookup('simp_options::*', { 'default_value' => ... })` with an explicit
default rather than assuming `simp_options` is included.

## Dependencies

Module dependencies (from `metadata.json`):

- `simp/simplib` `>= 4.9.0 < 6.0.0` (provides `simplib::lookup` and
  `simplib::assert_metadata`)
- `puppetlabs/stdlib` `>= 8.0.0 < 10.0.0` (standard SIMP baseline dependency; no
  stdlib function call is present in `manifests/`)

No optional dependencies are declared (`metadata.json` has no
`simp.optional_dependencies` block).

Fixture-only dependencies (from `.fixtures.yml`, checked out for test
compilation, not runtime deps): `simplib`, `stdlib`. Note there is **no**
`simp_options` fixture even though the manifests reference the
`simp_options::package_ensure` key.

Runtime requirement (from `metadata.json` `requirements`): `openvox >= 8.0.0 < 9.0.0`.

Supported OS matrix (from `metadata.json`): CentOS 9/10; RedHat 8/9/10;
OracleLinux 8/9/10; Rocky 8/9/10; AlmaLinux 8/9/10.

## Repository layout

- `manifests/init.pp` — the `mozilla` base class (`assert_metadata` only).
- `manifests/firefox.pp` — the `mozilla::firefox` class (installs `firefox`).
- `manifests/thunderbird.pp` — the `mozilla::thunderbird` class (installs
  `thunderbird`, supports `install_options`).
- `data/os/OracleLinux-7.yaml` — the only data file; sets thunderbird
  `install_options` for OL7 (an OS no longer in the support matrix).
- `hiera.yaml` — module data hierarchy (v5): OS name+major → OS name → common
  (only the first tier has a matching file).
- `metadata.json` — deps, OS matrix, OpenVox requirement.
- `spec/classes/init_spec.rb`, `spec/classes/firefox_spec.rb`,
  `spec/classes/thunderbird_spec.rb` — rspec-puppet unit tests (compile across
  `on_supported_os`).
- `spec/acceptance/suites/default/ff_spec.rb`,
  `spec/acceptance/suites/default/tb_spec.rb` — beaker acceptance tests (apply
  each class, assert idempotence and package installation); nodesets under
  `spec/acceptance/nodesets/`.
- `REFERENCE.md` — generated Puppet Strings reference.
- No `types/`, `lib/`, or `templates/` — this module has no custom data types,
  Ruby types/providers/functions/facts, or templates. Every function it uses
  comes from the dependencies above.
- **Acceptance runs in CI:** `.github/workflows/pr_tests.yml` has an
  `acceptance` job (matrix `almalinux9`, `almalinux10`) whose final step runs
  `bundle exec rake beaker:suites[default,<node>]` under
  `BEAKER_HYPERVISOR=vagrant_libvirt`.

## Common commands

```sh
# Install dependencies
bundle install

# Run all unit tests
bundle exec rake spec

# Run a single class spec
bundle exec rspec spec/classes/firefox_spec.rb

# Puppet lint
bundle exec rake lint

# Ruby lint
bundle exec rake rubocop

# Regenerate REFERENCE.md from puppet-strings docstrings
puppet strings generate --format markdown --out REFERENCE.md

# Run the default beaker acceptance suite
bundle exec rake beaker:suites[default]
```

Relevant gem pins (from `Gemfile`): `puppetlabs_spec_helper ~> 8.0.0`,
`simp-rake-helpers ~> 5.24.0`, `simp-rspec-puppet-facts ~> 4.0.0`,
`simp-beaker-helpers ~> 2.0.0`. Rubocop is pinned to `~> 1.88.0`. The test group
loads both `openvox` and `puppet` gems, defaulting to the `>= 8 < 9` range.
`spec/spec_helper.rb` uses `require 'puppetlabs_spec_helper/module_spec_helper'`.

## Conventions

- Preserve the `@summary` / `@param` puppet-strings docstrings on the classes —
  they drive `REFERENCE.md`. Regenerate `REFERENCE.md` after changing docs or
  parameters.
- Continue routing package-ensure and other SIMP feature toggles through
  `simplib::lookup('simp_options::*', { 'default_value' => ... })` with an
  explicit default rather than assuming `simp_options` is included.
- Keep `include 'mozilla'` in each feature class so `simplib::assert_metadata`
  always runs and gates the catalog on a supported OS.
- Keep OS/product-specific data (like thunderbird `install_options`) in module
  data under `data/`, not hard-coded in the manifests.
- `Gemfile`, `spec/spec_helper.rb`, `.gitignore`, and
  `.github/workflows/pr_tests.yml` carry a **puppetsync** notice — they are
  baseline-managed and the next sync overwrites local edits. Push changes to
  those files upstream to the baseline, not here.
- Match the existing 2-space Puppet indentation and aligned-arrow parameter
  style used in `manifests/`.
