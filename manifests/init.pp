# == Class: ldap_auth
#
# Configures ldap authentication on a host using pam.
# Supported distros/flavors are
#
# * Debian
# * RedHat EL5 + EL6
#
class ldap_auth {

  include ldap_auth::params
  include ldap_auth::install
  include ldap_auth::config

}
