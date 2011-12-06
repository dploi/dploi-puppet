class pythonutils {
    motd::register{"Python utilities": }
	package {
		'build-essential':
			ensure => latest;
			
		'python-dev':
		    ensure => latest;
			
		'python-setuptools':
			ensure => latest;
		
		'python-pip':
			ensure => latest;
		
		'python-imaging':
			ensure => latest;
			
		'python-memcache':
			ensure => latest;
			
		'python-psycopg2':
			ensure => latest;
			
		'python-mysqldb':
			ensure => latest;
		
		'python-virtualenv':
		    ensure => latest;
		    
	    'python-lxml':
		    ensure => latest;
	}
}