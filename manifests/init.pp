class ldap_auth ( $server="localhost", $base, $binddn, $bindpw, $filter ) {

  include ldap_auth::params

  package {
    $ldap_auth::params::packages:
      ensure => installed;
  }

  file { '/etc/nslcd.conf':
    owner   => 'root',
    group   => 'nslcd',
    mode    => 0640,
    content => template('ldap_auth/nslcd.conf.erb'),
    require => Package[$ldap_auth::params::packages],
    notify  => Service[$ldap_auth::params::nslcd_service],
  }

  service { $ldap_auth::params::nslcd_service:
    ensure => running,
    require => File["/etc/nslcd.conf"],
  }

  # set nsswitch.conf
  augeas { 'nsswitch.conf':
    context => "/files/etc/nsswitch.conf",
    changes => [
      "set /files/etc/nsswitch.conf/database[. = 'passwd']/service[2] ldap",
      "set /files/etc/nsswitch.conf/database[. = 'shadow']/service[2] ldap",
    ]
  }

	# only exec on rhel based systems as they use a tool to configure ldap auth
	# there is only nss support with nslcd for centos atm, so ldap_auth needs to go through the old pam_ldap way
	case $operatingsystem {
		"CentOS", "RedHat": {
			exec { "authconfig --enableldap --enableldapauth --ldapserver=$server --ldapbasedn=$base --enablemkhomedir --update":
				path => ["/usr/bin", "/usr/sbin"],
				require => Package[$ldap_auth::params::packages],
				unless => "/bin/grep 'ldap' /etc/nsswitch.conf",
        notify => Service["$ldap_auth::params::nslcd_service"],
        before => Augeas['nsswitch.conf'],
			}
    }
	}
}
