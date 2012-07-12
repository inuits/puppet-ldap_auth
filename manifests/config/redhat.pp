class ldap_auth::config::redhat {

  case $::operatingsystemrelease {
    /^6/: { include ldap_auth::config::redhat::6 }
    /^5/: { include ldap_auth::config::redhat::5 }
  }

}
