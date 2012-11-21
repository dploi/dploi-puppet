class munin {

}

class munin::client {
	motd::register{"Munin client":
		require => Package["munin-node"]
	}
	package {
		"munin-node":
			ensure => latest;
		"munin-plugins-extra":
			ensure => latest;
	}
	service {
		"munin-node":
			ensure => running,
			enable => true,
			hasrestart => true,
			hasstatus => true,
			require => Package["munin-node"],
	}
    @@munin::register{"${::fqdn}": }
	File <<| tag == "munin-node.conf" |>>
    $pluginfile = "/etc/munin/plugin-conf.d/puppet_plugins.conf"

    concat{$pluginfile:
       owner => root,
       group => root,
       mode  => 644
    }
    concat::fragment{"munin_plugin_empty":
       target  => $pluginfile,
       content => ""
    }
}

class munin::server {
	motd::register{"Munin server": }
	package { "munin":
		ensure => latest;
	}
    include concat::setup
    $concatfile = "/etc/munin/munin-conf.d/puppet.conf"

    concat{$concatfile:
       owner => root,
       group => root,
       mode  => 644
    }

    concat::fragment{"munin_header":
       target => $concatfile,
       content => "",
       order   => 01,
    }
	Munin::Register <<||>>
	@@file{
		"/etc/munin/munin-node.conf":
			content => template("munin/munin-node.conf.erb"),
			tag => "munin-node.conf",
			require => Package["munin-node"],
			notify => Service["munin-node"],
	}
}
define munin::register($content="", $order=10) {
   if $content == "" {
      $body = $name
   } else {
      $body = $content
   }

   concat::fragment{"munin_node_$name":
      target  => "/etc/munin/munin-conf.d/puppet.conf",
      content => "[$body]\naddress $body\n"
   }
}

define munin::plugin($pluginoptions="", $plugin="") {
	if $plugin != "" {
		$fname = $plugin
	} else {
		$fname = $name
	}
	file { "/etc/munin/plugins/$name":
		ensure => link,
		target => "/usr/share/munin/plugins/$fname",
		notify => Service["munin-node"],
		require => Package["munin-node"];
	}
	if $pluginoptions != ""{
		concat::fragment{"munin_plugin_$name":
			target  => "/etc/munin/plugin-conf.d/puppet_plugins.conf",
			content => "[$name]\n${pluginoptions}"
		}
	}
}

