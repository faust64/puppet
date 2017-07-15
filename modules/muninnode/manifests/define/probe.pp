define muninnode::define::probe($config      = false,
				$status      = "present",
				$pooled      = false,
				$plugin_name = false) {
    if (! defined(Class[Muninnode::Vars])) {
	include muninnode::vars
    }

    $conf_dir   = $muninnode::vars::munin_conf_dir
    $plugin_dir = $muninnode::vars::munin_plugins_dir

    if ($plugin_name) {
	$linkto = $plugin_name
    } else {
	$linkto = $name
    }

    if ($status == "present") {
	if ($pooled) {
	    file {
		"Enable pooling $name":
		    ensure  => link,
		    force   => true,
		    path    => "$conf_dir/plugins-pool/$name",
		    require => File["Install Munin-node pooler probes directory"],
		    target  => "$plugin_dir/$linkto";
		"Enable plugin $name":
		    ensure  => link,
		    force   => true,
		    notify  => Service[$muninnode::vars::munin_node_service_name],
		    path    => "$conf_dir/plugins/$name",
		    require => File["Prepare Munin-node plugins directory"],
		    target  => "$plugin_dir/pool_";
	    }
	} else {
	    file {
		"Enable plugin $name":
		    ensure  => link,
		    force   => true,
		    notify  => Service[$muninnode::vars::munin_node_service_name],
		    path    => "$conf_dir/plugins/$name",
		    require => File["Prepare Munin-node plugins directory"],
		    target  => "$plugin_dir/$linkto";
	    }
	}

	if ($config) {
	    file {
		"Install plugin $name configuration":
		    content => template("muninnode/plugin-conf/$config.erb"),
		    group   => lookup("gid_zero"),
		    mode    => "0644",
		    owner   => root,
		    path    => "$conf_dir/plugin-conf.d/$name.conf",
		    require => File["Prepare Munin-node plugin-conf directory"];
	    }
	}
    } else {
	if (defined(Service[$muninnode::vars::munin_node_service_name])) {
	    file {
		"Disable plugin $name":
		    ensure  => absent,
		    force   => true,
		    notify  => Service[$muninnode::vars::munin_node_service_name],
		    path    => "$conf_dir/plugins/$name";
	    }
	} else {
	    file {
		"Disable plugin $name":
		    ensure  => absent,
		    force   => true,
		    path    => "$conf_dir/plugins/$name";
	    }
	}

	if (defined(File["Prepare Munin-node plugins directory"])) {
	    File["Prepare Munin-node plugins directory"]
		-> File["Disable plugin $name"]
	}
    }
}
