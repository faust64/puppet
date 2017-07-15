class memcache::configrh {
    $listen  = $memcache::vars::listen
    $max_mem = $memcache::vars::max_mem
    $ruser   = $memcache::vars::runtime_user

    file {
	"Install memcache sysconfig configuration":
	    content => template("memcache/sysconfig.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$memcache::vars::service_name],
	    owner   => root,
	    path    => "/etc/sysconfig/memcached";
    }
}
