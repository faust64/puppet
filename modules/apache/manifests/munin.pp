class apache::munin {
    if ($apache::vars::munin_probes) {
	if ($apache::vars::munin_monitored) {
	    if (! defined(Class["muninnode"])) {
		include muninnode
	    }
	    if (! defined(Class["apache::status"])) {
		include apache::status
	    }

	    include common::libs::perlwww

	    $conf_dir = $apache::vars::munin_conf_dir

	    muninnode::define::probe {
		$apache::vars::munin_probes:
		    require => File["Install apache munin probe configuration"];
	    }

	    file {
		"Install apache munin probe configuration":
		    group   => lookup("gid_zero"),
		    mode    => "0644",
		    notify  => Service[$apache::vars::munin_service_name],
		    owner   => root,
		    path    => "$conf_dir/plugin-conf.d/apache.conf",
		    require => File["Prepare Munin-node plugin-conf directory"],
		    source  => "puppet:///modules/apache/munin.conf";
	    }

	    Class["common::libs::perlwww"]
		-> File["Install apache munin probe configuration"]
	} else {
	    muninnode::define::probe {
		$apache::vars::munin_probes:
		    status => "absent";
	    }
	}
    }
}
