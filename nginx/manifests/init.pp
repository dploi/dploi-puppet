class nginx {
    motd::register{"Nginx": }
	package {'nginx':
		ensure => latest,
	}
	service {'nginx':
		ensure => running,
		enable => true,
		hasrestart => true,
		hasstatus => true,
		require => Package['nginx'],
	}
	file { "/etc/nginx/nginx.conf":
        path => "/etc/nginx/nginx.conf",
        owner => root,
        group => root,
        mode => 644,
        require => Package['nginx'],
        content => template("nginx/nginx.conf.erb"),
        notify => Service['nginx']
    }
    file {
    	"/usr/share/nginx/www/":
    		require => File['/usr/share/nginx/'],
    		ensure => "directory";
    	"/usr/share/nginx/":
    		ensure => "directory",;
    }
	file { "/etc/nginx/sites-available/default":
        path => "/etc/nginx/sites-available/default",
        owner => root,
        group => root,
        mode => 644,
        require => Package['nginx'],
        content => template("nginx/nginx_default.erb"),
        notify => Service['nginx']
    }
    file { "/usr/share/nginx/www/index.html":
        path => "/usr/share/nginx/www/index.html",
        owner => root,
        group => root,
        mode => 644,
        require => [File['/etc/nginx/sites-available/default'], File['/usr/share/nginx/www/']],
        content => template("nginx/nginx_default_index.erb"),
    }
    @@nagios_service { "${::fqdn}_check_http_80":
		ensure => present,
		host_name => "${::fqdn}",
		notification_interval => 60,
		flap_detection_enabled => 1,
		service_description => "HTTP/nginx",
		check_command => "check_http!80",
		check_interval => "1",
		contact_groups => "serveradmins",
		use => "generic-service",
		target => "/etc/nagios3/conf.d/puppet.cfg";
	}
}