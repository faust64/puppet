class nginx::munin {
    if ($nginx::vars::munin_probes) {
	if ($nginx::vars::munin_monitored) {
	    if (! defined(Class[Muninnode])) {
		include muninnode
	    }
	    if (! defined(Class[Nginx::Status])) {
		include nginx::status
	    }

	    include common::libs::perlwww

	    $conf_dir     = $nginx::vars::munin_conf_dir
	    $listen_ports = $nginx::vars::listen_ports

	    muninnode::define::probe {
		$nginx::vars::munin_probes:
		    require => File["Install nginx munin probe configuration"];
	    }

	    file {
		"Install nginx munin probe configuration":
		    content => template("nginx/munin.erb"),
		    group   => lookup("gid_zero"),
		    mode    => "0644",
		    notify  => Service[$nginx::vars::munin_service_name],
		    owner   => root,
		    path    => "$conf_dir/plugin-conf.d/nginx.conf",
		    require => File["Prepare Munin-node plugin-conf directory"];
	    }
	} else {
	    muninnode::define::probe {
		$nginx::vars::munin_probes:
		    status => "absent";
	    }
	}
    }
}
