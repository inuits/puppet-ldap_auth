# == Class: ldap_auth::config
#
# Dispatches the ldap_auth configuration to different classes.
#
# * On redhat flavors: Includes `ldap_auth::config::redhat`
# * On debian flavors: Includes `ldap_auth::config::debian`
#
# In all cases `ldap_auth::config::common` is included.
#
class ldap_auth::config {

  case $::operatingsystem {
    /(?i:centos|redhat|fedora)/: { include ldap_auth::config::redhat }
    /(?i:debian|ubuntu)/:        { include ldap_auth::config::debian }
    default:                     {}
  }

  include ldap_auth::config::common

}
