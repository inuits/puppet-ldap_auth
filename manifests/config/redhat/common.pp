class ldap_auth::config::redhat::common {

  exec {'enableldap':
    command => "authconfig --enableldap --enableldapauth --ldapserver=${::ldap_auth::params::_server} --ldapbasedn=${::ldap_auth::params::_base} --enablemkhomedir --update",
    path    => ['/usr/bin', '/usr/sbin'],
    require => Package[$::ldap_auth::params::_packages],
    unless  => '/bin/grep "ldap" /etc/nsswitch.conf',
    before  => Augeas['nsswitch.conf'],
    notify  => operatingsystemrelease ? {
      /^6/    => Service[$::ldap_auth::params::_nslcd_service],
      default => undef,
    },
  }

}
