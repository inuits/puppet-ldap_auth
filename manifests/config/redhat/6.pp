class ldap_auth::config::redhat::6 {

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
    require => File['/etc/nslcd.conf'],
  }

  group{'nslcd':
    ensure => 'present',
    gid    => '7050',
  }

  augeas{'authconfig':
    context => '/files/etc/authconfig',
    changes => [
      'set /files/etc/sysconfig/authconfig/USELDAPAUTH yes',
      'set /files/etc/sysconfig/authconfig/USELDAP yes',
      'set /files/etc/sysconfig/authconfig/USEMKHOMEDIR yes',
    ]
  }


  ldap_auth::config::redhat::common::pam_config { ['password-auth', 'system-auth']: }

}
