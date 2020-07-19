class unbound::munin {
    if ($unbound::vars::munin_probes) {
	if ($unbound::vars::munin_monitored) {
	    if (! defined(Class["muninnode"])) {
		include muninnode
	    }

	    $conf_dir  = $unbound::vars::conf_dir
	    $mconf_dir = $unbound::vars::munin_conf_dir

	    muninnode::define::probe {
		$unbound::vars::munin_probes:
		    plugin_name => "unbound_",
		    require     => File["Install unbound munin probe configuration"];
	    }

	    file {
		"Install unbound munin probe configuration":
		    content => template("unbound/munin.erb"),
		    group   => lookup("gid_zero"),
		    mode    => "0644",
		    notify  => Service[$unbound::vars::munin_service_name],
		    owner   => root,
		    path    => "$mconf_dir/plugin-conf.d/unbound.conf",
		    require => File["Prepare Munin-node plugin-conf directory"],
	    }
	} else {
	    muninnode::define::probe {
		$unbound::vars::munin_probes:
		    status => "absent";
	    }
	}
    }
}
