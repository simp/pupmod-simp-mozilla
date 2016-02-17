# == Class: mozilla::thunderbird
#
# Install mozilla thunderbird for the correct architecture.
#
# == Authors
#
# * Trevor Vaughan <tvaughan@onyxpoint.com>
#
class mozilla::thunderbird {

  package { "thunderbird.${::hardwaremodel}":
    ensure => 'latest'
  }
}
