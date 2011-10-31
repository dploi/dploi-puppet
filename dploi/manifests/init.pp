import "dploi/projects"
import "dploi/admins"

class dploi {
    
}

define dploi::customer($project, $state, $uid, $gid=502, $enabled="true", $loadbalance="false") {
    basecustomer{
        "$project-$state":
            uid => $uid,
            gid => $gid,
    }
    motd::customer_register {$name:}
}