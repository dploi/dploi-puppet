define supervisor::program($command, $directory, $user, $autostart="True", $autorestart="True", $redirect_stderr="True", $environment="") {
	require supervisor
	file {"/etc/supervisor/conf.d/$name.conf":
		content => template("supervisor/program.erb"),
	}
	exec {"/usr/bin/supervisorctl update $name":
		require => [File["/etc/supervisor/conf.d/$name.conf"], Package["supervisor"]],
	}
}