class ldap_auth::install {

  package{"$ldap_auth::params::packages":
    ensure => installed,
  }

}
