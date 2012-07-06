class ldap_auth::config::redhat {

  file{'/etc/nslcd.conf':
    owner   => 'root',
    group   => 'nslcd',
    mode    => '0640',
    content => template('ldap_auth/nslcd.conf.erb'),
    require => Package[$::ldap_auth::params::_packages],
    notify  => Service[$::ldap_auth::params::_nslcd_service],
  }

  service{$::ldap_auth::params::_nslcd_service:
    ensure  => 'running',
    require => File["/etc/nslcd.conf"],
  }

  exec{"authconfig --enableldap --enableldapauth --ldapserver=$::ldap_auth::params::_server --ldapbasedn=$::ldap_auth::params::_base --enablemkhomedir --update":
    path    => ["/usr/bin", "/usr/sbin"],
    require => Package[$::ldap_auth::params::_packages],
    unless  => '/bin/grep "ldap" /etc/nsswitch.conf',
    notify  => Service[$::ldap_auth::params::_nslcd_service],
    before  => Augeas['nsswitch.conf'],
  }

  group{'nslcd':
    ensure => 'present',
    gid    => '7050',
  }

}
