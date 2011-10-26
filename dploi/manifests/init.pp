import dploi::projects

define dploi::customer($project, $state, $uid, $gid=502, $enabled="true", $loadbalance="false") {
	require groups::customers
    basecustomer{
        "$project-$state":
            uid => $uid,
            gid => $gid,
    }
    motd::customer_register {$name:}
}