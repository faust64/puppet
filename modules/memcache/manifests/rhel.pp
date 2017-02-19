class memcache::rhel {
    common::define::package {
	[ "memcached", "python-memcached" ]:
    }

    Package["memcached"]
	-> File["Install memcache sysconfig configuration"]
	-> Service[$memcache::vars::service_name]
}
