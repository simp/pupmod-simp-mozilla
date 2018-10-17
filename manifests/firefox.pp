# A class to install mozilla firefox
#
# @param package_ensure The ensure status of the firefox package
#
# @author https://github.com/simp/pupmod-simp-mozilla/graphs/contributors
#
class mozilla::firefox (
  String $package_ensure = simplib::lookup('simp_options::package_ensure', { 'default_value' => 'installed' }),
) {
  include 'mozilla'

  package { 'firefox':
    ensure => $package_ensure
  }
}
