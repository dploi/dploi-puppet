import "dploi/projects"
import "dploi/admins"

class dploi {
    
}

define dploi::customer($project, $state, $uid, $gid=502, $enabled="true", $loadbalance="false") {
    $tmpusername = "$project-$state"
    basecustomer{
        $tmpusername:
            uid => $uid,
            gid => $gid,
    }
    motd::customer_register {$name:}
    
    sudo::sudo_user{
        $project:
            user => "$tmpusername":
            privileges => [
                "ALL=(root) NOPASSWD:/usr/bin/supervisorctl restart $tmpusername,/usr/bin/supervisorctl add $tmpusername,/usr/bin/supervisorctl update $tmpusername,/usr/bin/supervisorctl start $tmpusername,/usr/bin/supervisorctl stop $tmpusername,/usr/bin/supervisorctl status $tmpusername,/etc/init.d/nginx reload $tmpusername"
            ]
    }
}