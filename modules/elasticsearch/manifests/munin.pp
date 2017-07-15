class elasticsearch::munin {
    if ($elasticsearch::vars::munin_probes) {
	if ($elasticsearch::vars::munin_monitored) {
	    if (! defined(Class[Muninnode])) {
		include muninnode
	    }

	    include common::libs::perllwpua
	    include common::libs::perljson

	    $conf_dir    = $elasticsearch::vars::munin_conf_dir
	    $listen_addr = $elasticsearch::vars::listen_addr

	    muninnode::define::probe {
		$elasticsearch::vars::munin_probes:
		    require => File["Install elasticsearch munin probe configuration"];
	    }

	    file {
		"Install elasticsearch munin probe configuration":
		    content => template("elasticsearch/munin.erb"),
		    group   => lookup("gid_zero"),
		    mode    => "0644",
		    notify  => Service[$elasticsearch::vars::munin_service_name],
		    owner   => root,
		    path    => "$conf_dir/plugin-conf.d/elasticsearch.conf",
		    require => File["Prepare Munin-node plugin-conf directory"];
	    }

	    Class[Common::Libs::Perllwpua]
		-> Class[Common::Libs::Perljson]
		-> File["Install elasticsearch munin probe configuration"]
	} else {
	    muninnode::define::probe {
		$elasticsearch::vars::munin_probes:
		    status => "absent";
	    }
	}
    }
}
