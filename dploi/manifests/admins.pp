define unixaccount($username, $uid, $gid, $enabled="true") {
	if ($myshell) {
		$shell = $myshell
	} else {
		$shell = "/bin/bash"
	}	

	user { "${username}":
		name		=> $username,
		uid		    => $uid,
		gid		    => $gid,
		comment		=> $title,
		shell		=> $shell,
		ensure		=> $enabled ? {
					"false" => 'absent',
					default => 'present',
				},
		allowdupe	=> false,
		require		=> Group[$gid],
		managehome => true,
	}
}

define developer_ssh_key($developer, $key, $device, $enabled)
{
    ssh_authorized_key {
		"$device@$username":
			ensure	=> $enabled ? {
						"false" => 'absent',
						default => 'present',
					},
			user => $username,
			type => "ssh-rsa",
			key	=> $key,
	}
}

define developer($username, $uid, $gid, $status, $enabled="true") {
    unixaccount{ $name:
        username => $username, uid => $uid, gid => $gid
    }
    Developer_ssh_key <| developer==$username |>
}