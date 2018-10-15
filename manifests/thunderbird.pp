# Install mozilla thunderbird
#
# @param package_ensure The ensure status of the thunderbird package
#
# @author https://github.com/simp/pupmod-simp-mozilla/graphs/contributors
#
class mozilla::thunderbird (
  String $package_ensure = simplib::lookup('simp_options::package_ensure', { 'default_value' => 'installed' }),
) {
  include 'mozilla'

  package { 'thunderbird':
    ensure => $package_ensure
  }
}
