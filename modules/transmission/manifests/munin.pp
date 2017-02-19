class transmission::munin {
    if ($transmission::vars::munin_probes) {
	if ($transmission::vars::munin_monitored) {
	    if (! defined(Class[Muninnode])) {
		include muninnode
	    }

	    $conf_dir = $transmission::vars::munin_conf_dir

	    case $operatingsystem {
		"Debian", "Ubuntu": {
		    $dependency = "libjson-rpc-perl"
		}
	    }

	    muninnode::define::probe {
		$transmission::vars::munin_probes:
		    plugin_name => "transmission_",
		    require     => File["Install transmission munin probe configuration"];
	    }

	    file {
		"Install transmission munin probe configuration":
		    group   => hiera("gid_zero"),
		    mode    => "0644",
		    notify  => Service[$transmission::vars::munin_service_name],
		    owner   => root,
		    path    => "$conf_dir/plugin-conf.d/transmission.conf",
		    require => File["Prepare Munin-node plugin-conf directory"],
		    source  => "puppet:///modules/transmission/munin.conf";
	    }

	    if ($dependency) {
		common::define::package {
		    $dependency:
		}

		Package[$dependency]
		    -> File["Install transmission munin probe configuration"]
	    }
	} else {
	    muninnode::define::probe {
		$transmission::vars::munin_probes:
		    status => "absent";
	    }
	}
    }
}
