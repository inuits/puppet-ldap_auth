# == Class: ldap_auth::config::common
#
# Uses augeas to configure /etc/nsswitch.conf.
#
# Adds the ldap service to passwd, shadow and group.
#
class ldap_auth::config::common {

  augeas{'nsswitch.conf':
    context => '/files/etc/nsswitch.conf',
    changes => [
      'set /files/etc/nsswitch.conf/database[. = "passwd"]/service[2] ldap',
      'set /files/etc/nsswitch.conf/database[. = "shadow"]/service[2] ldap',
      'set /files/etc/nsswitch.conf/database[. = "group" ]/service[2] ldap',
    ]
  }

}
