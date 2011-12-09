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
        require => File['/etc/nginx/sites-available/default'],
        content => template("nginx/nginx_default_index.erb"),
    }
}