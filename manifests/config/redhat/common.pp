# == Class: ldap_auth::config::redhat::common
#
# RedHat EL* overlapping configuration.
#
# * Adjusts /etc/pam_ldap.conf.
# * Configures /etc/nsswitch.conf (using augeas).
#
class ldap_auth::config::redhat::common {

  file {'/etc/pam_ldap.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('ldap_auth/pam_ldap.conf.erb'),
    require => Package[$::ldap_auth::params::private_packages],
    notify  => operatingsystemrelease ? {
      /^6/    => Service[$::ldap_auth::params::private_nslcd_service],
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

}
