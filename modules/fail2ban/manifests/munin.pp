class fail2ban::munin {
    if ($fail2ban::vars::munin_probes) {
	if ($fail2ban::vars::munin_monitored) {
	    if (! defined(Class[Muninnode])) {
		include muninnode
	    }

	    $conf_dir = $fail2ban::vars::munin_conf_dir

	    muninnode::define::probe {
		$fail2ban::vars::munin_probes:
	    }

	    file {
		"Install fail2ban munin probe configuration":
		    group   => lookup("gid_zero"),
		    mode    => "0644",
		    notify  => Service[$fail2ban::vars::munin_service_name],
		    owner   => root,
		    path    => "$conf_dir/plugin-conf.d/fail2ban.conf",
		    require => File["Prepare Munin-node plugin-conf directory"],
		    source  => "puppet:///modules/fail2ban/munin.conf";
	    }
	} else {
	    muninnode::define::probe {
		$fail2ban::vars::munin_probes:
		    status => "absent";
	    }
	}
    }
}
