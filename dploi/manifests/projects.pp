class dploi::projects {
	define configuration($username=$username) {
		
		file { "/home/$username/code":
			ensure => absent, # Deprecated, now called "app"
			owner => $username,
		}
		file { "/home/$username/app":
			ensure => directory,
			owner => $username,
		}
		file { "/home/$username/config":
			ensure => directory,
			owner => $username,
		}
		file { "/home/$username/log":
			ensure => directory,
			owner => $username,
		}
		file { "/home/$username/log/nginx":
			ensure => directory,
			owner => $username,
			require => File["/home/$username/log"];
		}
		file { "/home/$username/static":
			ensure => directory,
			owner => $username,
		}
		file { "/home/$username/upload":
			ensure => directory,
			owner => $username,
		}

		file { "/home/$username/upload/media":
			ensure => directory,
 			owner => $username,
			require => File["/home/$username/upload"];
		}
		
		file { "/home/$username/tmp":
			ensure => directory,
			owner => $username,
		}
		
		file { "/home/$username/config/django.py":
			ensure => present,
			owner => $username,
			require => File["/home/$username/config"];
		}
		
		file { "/home/$username/config/supervisor.conf":
			ensure => present,
			owner => $username,
			require => File["/home/$username/config"];
		}

		file { "/etc/supervisor/conf.d/$username.conf":
		    ensure => link,
		    target => "/home/$username/config/supervisor.conf",
			require => [File["/home/$username/config/supervisor.conf"], Package['supervisor']];
		}

		file { "/home/$username/config/nginx.conf":
			ensure => present,
			owner => $username,
			require => File["/home/$username/config"];
		}

		file { "/etc/nginx/sites-enabled/$username.conf":
		    ensure => link,
		    target => "/home/$username/config/nginx.conf",
			require => [File["/home/$username/config/nginx.conf"], Package['nginx']];
		}
	}
}

define dploi::basecustomer($uid, $gid) {
	$username = $name
	unixaccount { $username: username => $username, uid => $uid, gid => $gid }
	sshauthkeys{ $username: keys => hiera_array('team') }
	
	dploi::projects::configuration{
		$username:
	}
	
	postgres::role{
	    $username:
	        ensure => present,
	}
	
	postgres::database{
	    $username:
	        ensure => present,
	        owner => $username,
	        require => Postgres::Role[$username];
	}
}