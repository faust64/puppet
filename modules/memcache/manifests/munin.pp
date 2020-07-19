class memcache::munin {
    if ($memcache::vars::munin_probes) {
	if ($memcache::vars::munin_monitored) {
	    if (! defined(Class["muninnode"])) {
		include muninnode
	    }

	    $conf_dir = $memcache::vars::munin_conf_dir

	    muninnode::define::probe {
		$memcache::vars::munin_probes:
		    plugin_name => "memcached_multi_";
	    }
	} else {
	    muninnode::define::probe {
		$memcache::vars::munin_probes:
		    status => "absent";
	    }
	}
    }
}
