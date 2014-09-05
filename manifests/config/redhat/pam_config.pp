# == Definition: ldap_auth::config::redhat::pam_config
#
# Configures pam authentication services using augeas for redhat flavors.
#
# === Parameters:
#
# [*name*]    The pam module to configure.
#
define ldap_auth::config::redhat::pam_config() {

  augeas {"${name}_auth":
    context => "/files/etc/pam.d/${name}",
    changes => [
      'ins 01 before *[type = "auth"][module = "pam_deny.so"]',
      'set 01/type auth',
      'set 01/control sufficient',
      'set 01/module pam_ldap.so',
      'set 01/argument use_first_pass',
    ],
    onlyif  => 'get *[type = "auth"][module = "pam_ldap.so"][argument = "use_first_pass"]/type != auth',
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
    onlyif  => 'get *[type = "account"][control = "[default=bad success=ok user_unknown=ignore]"][module = "pam_ldap.so"]/type != account',
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
    onlyif  => 'get *[type = "password"][control = "sufficient"][module = "pam_ldap.so"][argument = "use_authtok"]/type != password',
  }

  augeas {"${name}_session_pam_mkhomedir":
    context => "/files/etc/pam.d/${name}",
    changes => [
      'ins 01 after *[type = "session"][control = "required"][module = "pam_limits.so"]',
      'set 01/type session',
      'set 01/control optional',
      'set 01/module pam_mkhomedir.so',
    ],
    onlyif  => 'get *[type = "session"][control = "optional"][module = "pam_mkhomedir.so"]/type != session',
  }

  augeas {"${name}_session_pam_ldap":
    context => "/files/etc/pam.d/${name}",
    changes => [
      'ins 01 after *[type = "session"][last()]',
      'set 01/type session',
      'set 01/control optional',
      'set 01/module pam_ldap.so',
    ],
    onlyif  => 'get *[type = "session"][control = "optional"][module = "pam_ldap.so"]/type != session',
  }
}
