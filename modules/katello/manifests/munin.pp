class katello::munin {
    include apache::munin

    Exec["Reload Katello Services"]
	-> Class["apache::munin"]

    if ($katello::vars::munin_probes) {
	if ($katello::vars::munin_monitored) {
	    if (! defined(Class[Muninnode])) {
		include muninnode
	    }

	    muninnode::define::probe {
		$katello::vars::munin_probes:
		    require => File["Install katello munin probe configuration"];
	    }

	    $conf_dir = $katello::vars::munin_conf_dir

	    file {
		"Install katello munin probe configuration":
		    group   => lookup("gid_zero"),
		    mode    => "0644",
		    notify  => Service[$katello::vars::munin_service_name],
		    owner   => root,
		    path    => "$conf_dir/plugin-conf.d/katello.conf",
		    require =>
			[
			    File["Prepare Munin-node plugin-conf directory"],
			    Exec["Reload Katello Services"]
			],
		    source  => "puppet:///modules/katello/munin.conf";
	    }
	} else {
	    muninnode::define::probe {
		$katello::vars::munin_probes:
		    status => "absent";
	    }
	}
    }
}
