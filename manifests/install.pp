class ldap_auth::install {

  package{$ldap_auth::params::_packages:
    ensure => installed,
  }

}
