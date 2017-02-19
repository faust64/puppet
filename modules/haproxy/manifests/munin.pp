class haproxy::munin {
    if ($haproxy::vars::munin_probes) {
	if ($haproxy::vars::munin_monitored) {
	    if (! defined(Class[Muninnode])) {
		include muninnode
	    }

	    include common::libs::perllwpua

	    $conf_dir         = $haproxy::vars::munin_conf_dir
	    $stats_listen     = $haproxy::vars::stats_listen
	    $stats_passphrase = $haproxy::vars::stats_passphrase
	    $stats_port       = $haproxy::vars::stats_port
	    $stats_user       = $haproxy::vars::stats_user

	    muninnode::define::probe {
		$haproxy::vars::munin_probes:
		    require => File["Install HAproxy munin probe configuration"];
	    }

	    file {
		"Install HAproxy munin probe configuration":
		    content => template("haproxy/munin.erb"),
		    group   => hiera("gid_zero"),
		    mode    => "0644",
		    notify  => Service[$haproxy::vars::munin_service_name],
		    owner   => root,
		    path    => "$conf_dir/plugin-conf.d/haproxy.conf",
		    require => File["Prepare Munin-node plugin-conf directory"];
	    }
	} else {
	    muninnode::define::probe {
		$haproxy::vars::munin_probes:
		    status => "absent";
	    }
	}
    }
}
