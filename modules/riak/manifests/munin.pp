class riak::munin {
    if ($riak::vars::munin_probes) {
	if ($riak::vars::munin_monitored) {
	    if (! defined(Class[Muninnode])) {
		include muninnode
	    }
	    include common::libs::pythonrequests

	    $basic     = $riak::vars::munin_basic
	    $conf_dir  = $riak::vars::munin_conf_dir
	    $port_http = $riak::vars::port_http
	    $riak_ssl  = $riak::vars::riak_ssl

	    file {
		"Install riak munin probe configuration":
		    content => template("riak/munin.erb"),
		    group   => lookup("gid_zero"),
		    mode    => "0640",
		    notify  => Service[$riak::vars::munin_service_name],
		    owner   => root,
		    path    => "$conf_dir/plugin-conf.d/riak.conf",
		    require => File["Prepare Munin-node plugin-conf directory"];
	    }

	    muninnode::define::probe {
		$riak::vars::munin_probes:
		    require => File["Install riak munin probe configuration"];
	    }
	} else {
	    muninnode::define::probe {
		$riak::vars::munin_probes:
		    status => "absent";
	    }
	}
    }
}
