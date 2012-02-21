class git {
    motd::register{"Git": }
    
    $gitpackagename = $::lsbdistrelease ? {
    	'10.04' => 'git-core',
    	default => 'git',
    }
    
	package {
		$gitpackagename:
			ensure => latest;
	}
}