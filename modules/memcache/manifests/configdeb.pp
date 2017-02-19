class memcache::configdeb {
    $conf_dir = $memcache::vars::conf_dir
    $listen   = $memcache::vars::listen
    $max_mem  = $memcache::vars::max_mem
    $ruser    = $memcache::vars::runtime_user

    if ($conf_dir != "/etc") {
	file {
	    "Prepare memcache for further configuration":
		ensure => directory,
		group  => hiera("gid_zero"),
		mode   => "0755",
		owner  => root,
		path   => $conf_dir;
	}

	File["Prepare memcache for further configuration"]
	    -> File["Install memcache main configuration"]
    }

    file {
	"Install memcache main configuration":
	    content => template("memcache/config.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$memcache::vars::service_name],
	    owner   => root,
	    path    => "$conf_dir/memcached.conf";
    }
}
