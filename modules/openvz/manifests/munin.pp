class openvz::munin {
    if ($openvz::vars::munin_probes) {
	if ($openvz::vars::munin_monitored) {
	    if (! defined(Class[Muninnode])) {
		include muninnode
	    }

	    $conf_dir = $openvz::vars::munin_conf_dir

	    muninnode::define::probe { $openvz::vars::munin_probes: }

	    file {
		"Install openvz munin probe configuration":
		    group   => hiera("gid_zero"),
		    mode    => "0644",
		    notify  => Service[$openvz::vars::munin_service_name],
		    owner   => root,
		    path    => "$conf_dir/plugin-conf.d/openvz.conf",
		    require => File["Prepare Munin-node plugin-conf directory"],
		    source  => "puppet:///modules/openvz/munin.conf";
	    }
	} else {
	    muninnode::define::probe {
		$openvz::vars::munin_probes:
		    status => "absent";
	    }
	}
    }
}
