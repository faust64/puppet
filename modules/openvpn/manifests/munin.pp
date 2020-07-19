class openvpn::munin {
    if ($openvpn::vars::munin_probes) {
	if ($openvpn::vars::munin_monitored) {
	    if (! defined(Class["muninnode"])) {
		include muninnode
	    }

	    muninnode::define::probe { $openvpn::vars::munin_probes: }
	} else {
	    muninnode::define::probe {
		$openvpn::vars::munin_probes:
		    status => "absent";
	    }
	}
    }
}
