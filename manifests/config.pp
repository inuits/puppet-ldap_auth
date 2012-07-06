class ldap_auth::config {

  case $::operatingsystem {
    /(?i:centos|redhat|fedora)/: { include ldap_auth::config::redhat }
    default:                     {}
  }

  include ldap_auth::config::common

}
