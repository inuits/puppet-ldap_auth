class ldap_auth::params {

  case $::operatingsystem {
    'CentOS', 'RedHat', 'Fedora': {
      $packages = [ "nss-pam-ldapd.x86_64" ]
      $nslcd_service = nslcd
      realize(Group["nslcd"])
    }

    'Debian': {
      $packages = [ "libnss-ldapd" , "libpam-ldapd" ]
      $nslcd_service = nslcd
    }
  }

  @group { "nslcd":
          ensure => present,
          gid => 7050
  }


}
