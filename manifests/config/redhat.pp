# == Class: ldap_auth::config::redhat
#
# Splits redhat configuration into major version specific configuration
# and includes a overlapping common class.
#
class ldap_auth::config::redhat {

  case $::operatingsystemrelease {
    /^6/: { include ::ldap_auth::config::redhat::6 }
    /^5/: { include ::ldap_auth::config::redhat::5 }
    default: {
      notice("This operating system release '${::operatingsystemrelease}' is not supported.")
    }
  }

  include ::ldap_auth::config::redhat::common

}
