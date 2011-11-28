class fail2ban {
    motd::register{"Fail2Ban": }
	package {'fail2ban':
		ensure => latest,
	}
	service {'fail2ban':
		ensure => running,
		enable => true,
		hasrestart => true,
		hasstatus => true,
		require => Package['fail2ban'],
	}
}