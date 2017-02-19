class spamassassin::munin {
    if ($spamassassin::vars::munin_probes) {
	if ($spamassassin::vars::munin_monitored) {
	    if (! defined(Class[Muninnode])) {
		include muninnode
	    }

	    muninnode::define::probe {
		$spamassassin::vars::munin_probes:
	    }
	} else {
	    muninnode::define::probe {
		$spamassassin::vars::munin_probes:
		    status => "absent";
	    }
	}
    }
}
