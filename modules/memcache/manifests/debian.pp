class memcache::debian {
    common::define::package {
	[ "memcached", "python-memcache" ]:
    }

    file {
	"Install memcached service defaults":
	    group  => lookup("gid_zero"),
	    mode   => "0644",
	    notify => Service[$memcache::vars::service_name],
	    owner  => root,
	    path   => "/etc/default/memcached";
    }

    Common::Define::Package["memcached"]
	-> File["Install memcached service defaults"]
	-> File["Install memcache main configuration"]
	-> Common::Define::Service[$memcache::vars::service_name]
}
