# == Class: ldap_auth::config::redhat::5
#
# RedHat EL5 specific configuration.
#
# * Creates /etc/ldap.conf.
# * Sets /etc/ldap.secret.
# * Disables nscd service.
# * Configures pam system-auth.
#
class ldap_auth::config::redhat::5 {

  File{
    owner => 'root',
    group => 'root',
  }

  file{'/etc/ldap.conf':
    mode    => '0644',
    content => template('ldap_auth/ldap.conf.erb'),
  }

  file{'/etc/ldap.secret':
    mode    => '0600',
    content => "${ldap_auth::params::_bindpw}\n",
  }

  service{'nscd':
    ensure => 'stopped',
  }

  ldap_auth::config::redhat::pam_config { 'system-auth': }
}
