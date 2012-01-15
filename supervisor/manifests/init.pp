import "program"
class supervisor {
	require pythonutils
    motd::register{"Supervisor":
		require => Package["supervisor"],
	}
	package {'supervisor':
		ensure => latest,
		require => Exec["supervisor-meld3-fix"];
	}
	service {'supervisor':
		ensure => running,
		enable => true,
		hasrestart => true,
		hasstatus => true,
		require => Package['supervisor'],
	}
	
	# Fix for supervisor bug: https://bugs.launchpad.net/ubuntu/+source/supervisor/+bug/777862
	exec { "supervisor-meld3-fix":
		command => "pip install elementtree",
	    #unless => "python -c 'import meld3'",
		require => Package['python-pip'],
		path => "/usr/bin:/usr/sbin",
  	}
}