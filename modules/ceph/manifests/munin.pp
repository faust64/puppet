class ceph::munin {
    if ($ceph::vars::munin_probes) {
	if ($ceph::vars::munin_monitored) {
	    if (! defined(Class[Muninnode])) {
		include muninnode
	    }

	    $conf_dir = $ceph::vars::munin_conf_dir

	    file {
		"Install ceph munin probe configuration":
		    group   => lookup("gid_zero"),
		    mode    => "0644",
		    notify  => Service[$ceph::vars::munin_service_name],
		    owner   => root,
		    path    => "$conf_dir/plugin-conf.d/ceph.conf",
		    require => File["Prepare Munin-node plugin-conf directory"],
		    source  => "puppet:///modules/ceph/munin.conf";
	    }

	    muninnode::define::probe {
		$ceph::vars::munin_probes:
		    require =>
			[
			    Common::Define::Package["ceph-common"],
			    File["Install ceph munin probe configuration"]
			];
	    }
	} else {
	    muninnode::define::probe {
		$ceph::vars::munin_probes:
		    status => "absent";
	    }
	}
    }
}
