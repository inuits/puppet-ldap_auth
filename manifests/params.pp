# == Class: ldap_auth::params
#
# Configures the default ldap_auth parameters based on
# the distribution used.
#
# If you want to add support for a new distribution, you
# will want to start here.
#
class ldap_auth::params (
  $packages      = undef,
  $server        = undef,
  $base          = undef,
  $binddn        = undef,
  $bindpw        = undef,
  $filter        = undef,
  $nslcd_service = undef,
  $ssl           = false,
) {

  ########################
  ####    Packages    ####
  ########################

  $private_packages = $packages ? {
    undef   => $::operatingsystem ? {
      /(CentOS|Redhat|Fedora)/  => $::operatingsystemrelease ? {
        default => [ "nss-pam-ldapd.${::architecture}" ],
        /^5/    => [ "nss_ldap.${::architecture}" ],
      },
      /(Debian|Ubuntu)/         => [ 'libnss-ldapd' , 'libpam-ldapd' ],
    },
    default => $packages,
  }

  ########################
  ####     Config     ####
  ########################

  $private_server = $server ? {
    undef   => 'localhost',
    default => $server,
  }

  $private_base   = $base ? {
    undef   => '',
    default => $base,
  }

  $private_binddn = $binddn ? {
    undef   => '',
    default => $binddn,
  }

  $private_bindpw = $bindpw ? {
    undef   => '',
    default => $bindpw,
  }

  $private_filter = $filter ? {
    undef   => '',
    default => $filter,
  }

  $private_ssl = $ssl ? {
    true    => 'yes',
    default => 'no',
  }

  ########################
  ####    Service     ####
  ########################

  $private_nslcd_service = $nslcd_service ? {
    undef   => 'nslcd',
    default => $nslcd_service,
  }

}
