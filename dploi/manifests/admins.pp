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
    sshauthkeys{ $username: keys => $keys }
}
class dploi::admin::enc-developer($developers) {
	# A wrapper around dploi::developer, to make it useable from ENC
	define encdeveloper() {
		$d = split($title, '[:]')
		$realname = $d[0]
		$username = $d[1]
		$uid = $d[2]
		$gid = $d[3]
		$status = $d[4]
		$keys = split(inline_template("<% d[5].each do |key| -%><%= key %><% end -%>"), '[ ]')
		developer{$realname:
			username => $username,
			uid => $uid,
			gid => $gid,
			status => $status,
			keys => $keys,
			enabled => $enabled,
		}
	}
	$developersarray = split(inline_template("<% developers.each do |key,val| -%><%= key %>:<%= val['username'] %>:<%= val['uid'] %>:<%= val['gid'] %>:<%= val['enabled'] %>:<% val['keys'].each do |sshkey| -%><%= sshkey %> <% end -%>;<% end -%>"), '[;]')
	encdeveloper{$developersarray:}
}
