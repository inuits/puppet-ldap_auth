# == Class: ldap_auth::install
#
# Installs the ldap auth package.
# Package name is defined in `ldap_auth::params`.
#
class ldap_auth::install {

  package {$::ldap_auth::params::_packages:
    ensure => 'installed',
  }

}
