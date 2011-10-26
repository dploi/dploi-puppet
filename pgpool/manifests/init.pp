class pgpool {
    motd::register{"Pgpool (client)": }
	package {'pgpool2':
		ensure => latest,
	}
	service {'pgpool2':
		ensure => running,
		enable => true,
		hasrestart => true,
		hasstatus => true,
		require => Package['pgpool2'],
	}
}