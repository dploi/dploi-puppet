class nginx {
    motd::register{"Nginx": }
	package {'nginx':
		ensure => latest,
	}
	service {'nginx':
		ensure => running,
		enable => true,
		hasrestart => true,
		hasstatus => true,
		require => Package['nginx'],
	}
}