# == Class: ldap_auth::config::debian
#
# Debian-ish specific configuration of the pam_mkhomedir configuration file.
# Uses augeas to change /etc/pam.d/common-session
#
class ldap_auth::config::debian {

  augeas{'pam_mkhomedir.so':
    context => '/files/etc/pam.d/common-session/100',
    changes => [
      'set type session',
      'set control required',
      'set module pam_mkhomedir.so',
      'set argument[1] umask=0022',
    ],
    onlyif  => 'get /files/etc/pam.d/common-session/*[module = "pam_mkhomedir.so"]/type != session',
  }

}
