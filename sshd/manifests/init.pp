class sshd {
    motd::register{"Passwordless SSH login": }
    file { "/etc/ssh/sshd_config":
        ensure => present,
        owner => 'root',
        group => 'root',
        mode => 0440,
        source => "puppet:///modules/sshd/sshd_config",
        notify => Service['ssh']
    }
    package {'openssh-server':
		ensure => latest,
	}
	service {'ssh':
		ensure => running,
		enable => true,
		hasrestart => true,
		hasstatus => true,
		require => Package['openssh-server'],
	}
}