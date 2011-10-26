class git {
    motd::register{"Git": }
	package {
		'git':
			ensure => latest;
	}
}