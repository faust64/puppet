class named::munin {
    if ($named::vars::munin_probes) {
	if ($named::vars::munin_monitored) {
	    if (! defined(Class[Muninnode])) {
		include muninnode
	    }

	    $conf_dir = $named::vars::munin_conf_dir
	    $log_dir  = $named::vars::log_dir

	    muninnode::define::probe {
		$named::vars::munin_probes:
		    require => File["Install named munin probe configuration"];
	    }

	    file {
		"Install named munin probe configuration":
		    content => template("named/munin.erb"),
		    group   => lookup("gid_zero"),
		    mode    => "0644",
		    notify  => Service[$named::vars::munin_service_name],
		    owner   => root,
		    path    => "$conf_dir/plugin-conf.d/named.conf",
		    require => File["Prepare Munin-node plugin-conf directory"];
	    }
	} else {
	    muninnode::define::probe {
		$named::vars::munin_probes:
		    status => "absent";
	    }
	}
    }
}
