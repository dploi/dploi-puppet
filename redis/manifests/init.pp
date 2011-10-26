class redis {
    motd::register{"Redis": }
	package {'redis-server':
		ensure => latest,
	}
	service {'redis-server':
		ensure => running,
		enable => true,
		hasrestart => true,
		hasstatus => true,
		require => Package['redis-server'],
	}
}