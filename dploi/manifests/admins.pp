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

define developer($username, $uid, $gid, $status, $keys=[], $enabled="true") {
    unixaccount{ $name:
        username => $username, uid => $uid, gid => $gid
    }
    sshauthkeys{ $username: keys => $team }
}