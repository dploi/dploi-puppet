import "frontend"

class nagios
{

}
class nagios::server {
	motd::register{"Nagios server": }
	# Put this in your own nagios class
	# nagios_contact { "yourname":
	# 	email => "your@email.com",
	# 	service_notification_period => "24x7",
	# 	host_notification_period => "24x7",
	# 	service_notification_options => "w,u,c,r,f",
	# 	host_notification_options => "d,r,f",
	# 	service_notification_commands => "notify-service-by-email",
	# 	host_notification_commands => "notify-host-by-email",
	# 	target => "/etc/nagios3/conf.d/puppet.cfg";
	# }
	# nagios_contactgroup {"serveradmins":
	# 	members => "yourname",
	# 	target => "/etc/nagios3/conf.d/puppet.cfg";
	# }
	package {'nagios3':
		alias => "nagios",
		ensure => latest;
	}
	service {'nagios3':
		alias => "nagios",
		ensure => running,
		enable => true,
		hasrestart => true,
		hasstatus => true,
		require => Package['nagios3'],
	}
	# Symlink nagios, so it works with the puppet config
	file { "/etc/nagios/":
		ensure => link,
		target => "/etc/nagios3/",
		mode => 644,
		require => Package["nagios3"];
	}
	# Collect everything else, which will be staying at the default level5…
	Nagios_host <<||>>
	Nagios_service <<||>>
	Nagios_hostgroup <<||>>
	Nagios_command <<||>>
}

class nagios::client {
	motd::register{"Nagios monitored client (SSH+Ping)": }
	# Nagios configuration
	@@nagios_host { "${::fqdn}":
		ensure => present,
		alias => "${::fqdn}",
		address => "${::ipaddress}",
		max_check_attempts =>  5,
		use => "generic-host",
		contact_groups => "serveradmins",
		target => "/etc/nagios3/conf.d/puppet.cfg";
	}
	@@nagios_service { "${::fqdn}_check_ping":
		ensure => present,
		host_name => "${::fqdn}",
		notification_interval => 60,
		flap_detection_enabled => 1,
		service_description => "Ping",
		check_command => "check_ping!300.0,20%!500.0,60%",
		check_interval => "1",
		contact_groups => "serveradmins",
		use => "generic-service",
		target => "/etc/nagios3/conf.d/puppet.cfg";
	}
	@@nagios_service { "${::fqdn}_check_ssh":
		ensure => present,
		host_name => "${::fqdn}",
		notification_interval => 60,
		check_interval => "1",
		flap_detection_enabled => 1,
		service_description => "SSH",
		check_command => "check_ssh",
		contact_groups => "serveradmins",
		use => "generic-service",
		target => "/etc/nagios3/conf.d/puppet.cfg";
	}
}
