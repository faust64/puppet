class postfix::munin {
    if ($postfix::vars::munin_probes) {
	if ($postfix::vars::munin_monitored) {
	    if (! defined(Class[Muninnode])) {
		include muninnode
	    }

	    $adm      = lookup("gid_adm")
	    $conf_dir = $postfix::vars::munin_conf_dir

	    muninnode::define::probe {
		$postfix::vars::munin_probes:
		    require => File["Install postfix munin probe configuration"];
	    }

	    file {
		"Install postfix munin probe configuration":
		    content => template("postfix/munin.erb"),
		    group   => lookup("gid_zero"),
		    mode    => "0644",
		    notify  => Service[$postfix::vars::munin_service_name],
		    owner   => root,
		    path    => "$conf_dir/plugin-conf.d/postfix.conf",
		    require => File["Prepare Munin-node plugin-conf directory"];
	    }
	} else {
	    muninnode::define::probe {
		$postfix::vars::munin_probes:
		    status => "absent";
	    }
	}
    }
}
