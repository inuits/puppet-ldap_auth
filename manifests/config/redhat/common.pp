class ldap_auth::config::redhat::common
{

  file {'/etc/pam_ldap.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('ldap_auth/pam_ldap.conf.erb'),
    require => Package[$::ldap_auth::params::_packages],
    notify  => operatingsystemrelease ? {
      /^6/    => Service[$::ldap_auth::params::_nslcd_service],
      default => undef,
    },
  }

  augeas{'redhat-nsswitch.conf':
    context => '/files/etc/nsswitch.conf',
    changes => [
      'set database[. = "passwd"]/service[1] files',
      'set database[. = "passwd"]/service[2] ldap',
      'set database[. = "shadow"]/service[1] files',
      'set database[. = "shadow"]/service[2] ldap',
      'set database[. = "group" ]/service[1] files',
      'set database[. = "group" ]/service[2] ldap',
      'set database[. = "netgroup" ]/service[1] files',
      'set database[. = "netgroup" ]/service[2] ldap',
      'set database[. = "automount" ]/service[1] files',
      'set database[. = "automount" ]/service[2] ldap',
    ]
  }

  define pam_config() {

    augeas {"${name}_auth":
      context => "/files/etc/pam.d/${name}",
      changes => [
        'ins 01 before *[type = "auth"][module = "pam_deny.so"]',
        'set 01/type auth',
        'set 01/control sufficient',
        'set 01/module pam_ldap.so',
        'set 01/argument use_first_pass',
      ],
      onlyif => 'get *[type = "auth"][module = "pam_ldap.so"][argument = "use_first_pass"]/type != auth',
    }

    augeas {"${name}_account_broken_shadow":
      context => "/files/etc/pam.d/${name}",
      changes => [
        'set *[type = "account"][control = "required"][module = "pam_unix.so"]/argument broken_shadow',
      ],
    }

    augeas {"${name}_account":
      context => "/files/etc/pam.d/${name}",
      changes => [
        'ins 01 before *[type = "account"][control = "required"][module = "pam_permit.so"]',
        'set 01/type account',
        'set 01/control "[default=bad success=ok user_unknown=ignore]"',
        'set 01/module pam_ldap.so',
      ],
      onlyif => 'get *[type = "account"][control = "[default=bad success=ok user_unknown=ignore]"][module = "pam_ldap.so"]/type != account',
    }

    augeas {"${name}_password":
      context => "/files/etc/pam.d/${name}",
      changes => [
        'ins 01 before *[type = "password"][control = "required"][module = "pam_deny.so"]',
        'set 01/type password',
        'set 01/control sufficient',
        'set 01/module pam_ldap.so',
        'set 01/argument use_authtok',
      ],
      onlyif => 'get *[type = "password"][control = "sufficient"][module = "pam_ldap.so"][argument = "use_authtok"]/type != password',
    }

    augeas {"${name}_session_pam_mkhomedir":
      context => "/files/etc/pam.d/${name}",
      changes => [
        'ins 01 after *[type = "session"][control = "required"][module = "pam_limits.so"]',
        'set 01/type session',
        'set 01/control optional',
        'set 01/module pam_mkhomedir.so',
      ],
      onlyif => 'get *[type = "session"][control = "optional"][module = "pam_mkhomedir.so"]/type != session',
    }

    augeas {"${name}_session_pam_ldap":
      context => "/files/etc/pam.d/${name}",
      changes => [
        'ins 01 after *[type = "session"][last()]',
        'set 01/type session',
        'set 01/control optional',
        'set 01/module pam_ldap.so',
      ],
      onlyif => 'get *[type = "session"][control = "optional"][module = "pam_ldap.so"]/type != session',
    }
  }
}
