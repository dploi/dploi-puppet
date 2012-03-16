class postgres::gis {
	package {
		"postgis":
			ensure => latest;
		"postgresql-9.1-postgis":
			ensure => latest;
		"proj":
			ensure => latest;
		"libgeos-3.2.2":
			ensure => latest;
		"gdal-bin":
			ensure => latest;
	}
	file {
		"/tmp/create_template_postgis-debian.sh":
			ensure => "present",
			source => "puppet:///modules/postgres/create_template_postgis-debian.sh",
	}
	exec {
		"/bin/bash /tmp/create_template_postgis-debian.sh":
			user => "postgres",
			unless => "/usr/bin/psql -l | grep 'template_postgis  *|'",
			require => [File['/tmp/create_template_postgis-debian.sh'], Service['postgresql']],
	}
}