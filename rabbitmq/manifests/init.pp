class rabbitmq {
    motd::register{"Rabbit-MQ": }
	package {'rabbitmq-server':
		ensure => latest,
	}
	service {'rabbitmq-server':
		ensure => running,
		enable => true,
		hasrestart => true,
		hasstatus => true,
		require => Package['rabbitmq-server'],
	}
}