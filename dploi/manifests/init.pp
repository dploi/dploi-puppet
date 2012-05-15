import "dploi/projects"
import "dploi/admins"

class dploi {
    
}

define dploi::customer($project, $state, $uid, $gid=502, $enabled="true", $loadbalance="false") {
    $tmpusername = "${project}-${state}"
    basecustomer{
        $tmpusername:
            uid => $uid,
            gid => $gid,
    }
    motd::customer_register {$name:}
    
    sudo::sudo_user{
        $tmpusername:
            user => "$tmpusername",
            privileges => [
                "ALL=(root) NOPASSWD:/usr/bin/supervisorctl restart $tmpusername*,/usr/bin/supervisorctl add $tmpusername*,/usr/bin/supervisorctl update $tmpusername*,/usr/bin/supervisorctl start $tmpusername*,/usr/bin/supervisorctl stop $tmpusername*,/usr/bin/supervisorctl status $tmpusername*,/etc/init.d/nginx reload"
            ]
    }
}

class dploi::enc-customer($projects) {
	# A wrapper around dploi::customer, to make it useable from ENC
	define project() {
		$p = split($title, '[:]')
		$project = $p[0]
		$state = $p[1]
		$uid = $p[2]
		$projectname = sprintf('%s-%s', $project, $state)
		dploi::customer{$projectname:
			project => $project,
			state => $state,
			uid => $uid,
		}
	}
	$project = inline_template("<% projects.each do |key,val| -%><%= key %>:<%= val['state'] %>:<%= val['uid'] %>;<% end -%>")
	$projectarray = split($project, '[ ;]')
	project{$projectarray:}
}