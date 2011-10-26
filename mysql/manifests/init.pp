class mysql {
    motd::register{"Mysql": }
	package {'mysql-server':
		ensure => latest,
	}
	service {'mysql':
		ensure => running,
		enable => true,
		hasrestart => true,
		hasstatus => true,
		require => Package['mysql-server'],
	}
}