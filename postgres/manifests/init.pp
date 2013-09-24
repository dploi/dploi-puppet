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
	file {'/usr/sbin/psqldumpdbs.sh':
		source => "puppet:///modules/postgres/psqldumpdbs.sh",
		mode => 755,
		require => Package['postgresql'],
	}
	file {'/backups':
		ensure => "directory",
	}
	file {'/backups/psql':
		ensure => "directory",
		mode => 0600,
		owner => "postgres",
		require => [ File["/backups"], Package['postgresql'] ],
	}
	cron {'psqldumpdbs':
		command => "/usr/sbin/psqldumpdbs.sh",
		user => postgres,
		hour => "0",
		require => File["/usr/sbin/psqldumpdbs.sh"];
	}
}