class mongodb::munin {
    if ($mongodb::vars::munin_probes) {
	if ($mongodb::vars::munin_monitored) {
	    if (! defined(Class["muninnode"])) {
		include muninnode
	    }

	    muninnode::define::probe {
		$mongodb::vars::munin_probes:
	    }
	} else {
	    muninnode::define::probe {
		$mongodb::vars::munin_probes:
		    status => "absent";
	    }
	}
    }
}
