class ldap_auth::config {

  case $::operatingsystem {
    /(?i:centos|redhat|fedora)/: { include ldap_auth::config::redhat }
    /(?i:debian|ubuntu)/:        { include ldap_auth::config::debian }
    default:                     {}
  }

  include ldap_auth::config::common

}
