class nagios::python-nagios-frontend (
		$object_file = '/var/cache/nagios3/objects.cache',
		$status_file = '/var/cache/nagios3/status.dat',
		$hostgroups = ['all']
	) {
	# Alternative frontend for nagios
	require supervisor
	package {"python-nagios-frontend":
		provider => "pip",
		ensure => "latest",
	}
	
	file {"/etc/python-nagios-frontend/":
		ensure => "directory",
		require => Package["python-nagios-frontend"],
	}
	
	file {"/etc/python-nagios-frontend/config.xml":
		content => template("nagios/python-nagios-frontend/config.xml.erb"),
		require => File["/etc/python-nagios-frontend/"]
	}
	
	supervisor::program{"python-nagios-frontend":
		command => "python-nagios-frontend",
		directory => "/etc/python-nagios-frontend/",
		user => "www-data",
		require => File["/etc/python-nagios-frontend/config.xml"]
	}
}