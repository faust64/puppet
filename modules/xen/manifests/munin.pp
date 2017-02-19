class xen::munin {
    if ($xen::vars::munin_probes) {
	if ($xen::vars::munin_monitored) {
	    if (! defined(Class[Muninnode])) {
		include muninnode
	    }

	    $conf_dir = $xen::vars::munin_conf_dir

	    file {
		"Install xen munin probe configuration":
		    group   => hiera("gid_zero"),
		    mode    => "0644",
		    notify  => Service[$xen::vars::munin_service_name],
		    owner   => root,
		    path    => "$conf_dir/plugin-conf.d/xen.conf",
		    require => File["Prepare Munin-node plugin-conf directory"],
		    source  => "puppet:///modules/xen/munin.conf";
	    }

	    muninnode::define::probe { $xen::vars::munin_probes: }
	} else {
	    muninnode::define::probe {
		$xen::vars::munin_probes:
		    status => "absent";
	    }
	}
    }
}
