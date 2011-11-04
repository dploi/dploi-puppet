
class sudo {
    
    motd::register{"Sudo": }
	
	define sudo_user( $user, $privileges ) {

		file { "/etc/sudoers.d/$name":
			owner => root,
			group => root,
			mode => 0440,
			content => template("sudo/sudoers.erb"),
			require => File["/etc/sudoers"],
		}
	}
	
	 file { "/etc/sudoers":
	   ensure => present,
	   owner => 'root',
	   group => 'root',
	   mode => 0440,
	   source => "puppet:///modules/sudo/etc/sudoers",
	 }
}
