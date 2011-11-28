class sshd {
    file { "/etc/ssh/sshd_config":
        ensure => present,
        owner => 'root',
        group => 'root',
        mode => 0440,
        source => "puppet:///modules/sshd/sshd_config",
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