class nsd::munin {
    if ($nsd::vars::munin_probes) {
	if ($nsd::vars::munin_monitored) {
	    if (! defined(Class[Muninnode])) {
		include muninnode
	    }

	    $conf_dir = $nsd::vars::munin_conf_dir
	    $log_dir  = $nsd::vars::log_dir
	    $run_dir  = $nsd::vars::run_dir
	    $username = $nsd::vars::runtime_user

	    muninnode::define::probe {
		$nsd::vars::munin_probes:
		    plugin_name => "nsd_",
		    require     => File["Install nsd munin probe configuration"];
	    }

	    file {
		"Install nsd munin probe configuration":
		    content => template("nsd/munin.erb"),
		    group   => lookup("gid_zero"),
		    mode    => "0644",
		    notify  => Service[$nsd::vars::munin_service_name],
		    owner   => root,
		    path    => "$conf_dir/plugin-conf.d/nsd.conf",
		    require => File["Prepare Munin-node plugin-conf directory"];
	    }
	} else {
	    muninnode::define::probe {
		$nsd::vars::munin_probes:
		    status => "absent";
	    }
	}
    }
}
