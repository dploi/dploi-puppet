class postgres {
    motd::register{"Postgres": }
	package {'postgresql':
		ensure => latest,
	}
	service {'postgresql':
		ensure => running,
		enable => true,
		hasrestart => true,
		hasstatus => true,
		require => Package['postgresql'],
	}
}