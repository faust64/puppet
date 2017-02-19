class redis::munin {
    if ($redis::vars::munin_probes) {
	if ($redis::vars::munin_monitored) {
	    if (! defined(Class[Muninnode])) {
		include muninnode
	    }
	    include common::libs::perlswitch

	    muninnode::define::probe {
		$redis::vars::munin_probes:
		    plugin_name => "redis_";
	    }
	} else {
	    muninnode::define::probe {
		$redis::vars::munin_probes:
		    status => "absent";
	    }
	}
    }
}
