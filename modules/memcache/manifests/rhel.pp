class memcache::rhel {
    common::define::package {
	[ "memcached", "python-memcached" ]:
    }

    Common::Define::Package["memcached"]
	-> File["Install memcache sysconfig configuration"]
	-> Common::Define::Service[$memcache::vars::service_name]
}
