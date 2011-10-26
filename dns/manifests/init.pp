
class dns::client {
    motd::register{"DNS/Resolv.conf": }
	 file { "/etc/resolv.conf":
	   ensure => present,
	   owner => 'root',
	   group => 'root',
	   mode => 0440,
	   source => "puppet:///modules/dns/etc/resolv.conf",
	 }
}
