class pf::munin {
    if ($pf::vars::munin_probes) {
	if ($pf::vars::munin_monitored) {
	    if (! defined(Class["muninnode"])) {
		include muninnode
	    }

	    $conf_dir = $pf::vars::munin_conf_dir

	    file {
		"Install pf munin probe configuration":
		    group   => lookup("gid_zero"),
		    mode    => "0644",
		    notify  => Service[$pf::vars::muninnode_service_name],
		    owner   => root,
		    path    => "$conf_dir/plugin-conf.d/pf.conf",
		    require => File["Prepare Munin-node plugin-conf directory"],
		    source  => "puppet:///modules/pf/munin.conf";
	    }

	    muninnode::define::probe { $pf::vars::munin_probes: }
	} else {
	    muninnode::define::probe {
		$pf::vars::munin_probes:
		    status => "absent";
	    }
	}
    }
}
