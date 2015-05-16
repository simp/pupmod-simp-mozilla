# == Class: mozilla::firefox
#
# A class to install mozilla firefox for the appropriate architecture.
#
# == Authors
#
# * Trevor Vaughan <tvaughan@onyxpoint.com>
#
class mozilla::firefox {

  package { "firefox.${::hardwaremodel}":
    ensure => 'latest'
  }
}
