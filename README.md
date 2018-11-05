[![License](https://img.shields.io/:license-apache-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0.html)
[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/73/badge)](https://bestpractices.coreinfrastructure.org/projects/73)
[![Puppet Forge](https://img.shields.io/puppetforge/v/simp/mozilla.svg)](https://forge.puppetlabs.com/simp/mozilla)
[![Puppet Forge Downloads](https://img.shields.io/puppetforge/dt/simp/mozilla.svg)](https://forge.puppetlabs.com/simp/mozilla)
[![Build Status](https://travis-ci.org/simp/pupmod-simp-mozilla.svg)](https://travis-ci.org/simp/pupmod-simp-mozilla)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with mozilla](#setup)
    * [What mozilla affects](#what-mozilla-affects)
    * [Beginning with mozilla](#beginning-with-mozilla)
6. [Development - Guide for contributing to the module](#development)
      * [Acceptance Tests - Beaker env variables](#acceptance-tests)

## Overview

This module provides classes to install Mozilla Firefox and Mozilla Thunderbird.

## This is a SIMP module

This module is a component of the [System Integrity Management Platform](https://simp-project.com),
a compliance-management framework built on Puppet.

If you find any issues, they can be submitted to our [JIRA](https://simp-project.atlassian.net/).

Please read our [Contribution Guide](http://simp-doc.readthedocs.io/en/stable/contributors_guide/index.html).

This module is optimally designed for use within a larger SIMP ecosystem, but it can be used independently:
* When included within the SIMP ecosystem, security compliance settings will be managed from the Puppet server.
* If used independently, all SIMP-managed security subsystems are disabled by default and must be explicitly opted into by administrators.  Please review the `client_nets` and `$enable_*` parameters in `manifests/init.pp` for details.


## Module Description

This module will only install Mozilla Firefox and Mozilla Thunderbird, depending on the class included.

## Setup

### What mozilla affects

The `firefox` and `thunderbird` packages.

### Beginning with mozilla

To install `firefox`:
```puppet
include 'mozilla::firefox'
```

To install `thunderbird`:
```puppet
include 'mozilla::thunderbird'
```

`init.pp` contains no code and including it will do nothing.

## Development

Please read our [Contribution Guide](http://simp-doc.readthedocs.io/en/stable/contributors_guide/index.html).

### Acceptance tests

To run the system tests, you need [Vagrant](https://www.vagrantup.com/) installed. Then, run:

```shell
bundle exec rake acceptance
```

Some environment variables may be useful:

```shell
BEAKER_debug=true
BEAKER_provision=no
BEAKER_destroy=no
BEAKER_use_fixtures_dir_for_modules=yes
```

* `BEAKER_debug`: show the commands being run on the STU and their output.
* `BEAKER_destroy=no`: prevent the machine destruction after the tests finish so you can inspect the state.
* `BEAKER_provision=no`: prevent the machine from being recreated. This can save a lot of time while you're writing the tests.
* `BEAKER_use_fixtures_dir_for_modules=yes`: cause all module dependencies to be loaded from the `spec/fixtures/modules` directory, based on the contents of `.fixtures.yml`.  The contents of this directory are usually populated by `bundle exec rake spec_prep`.  This can be used to run acceptance tests to run on isolated networks.
