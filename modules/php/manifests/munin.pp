class php::munin {
    if ($php::vars::munin_probes) {
	if ($php::vars::munin_monitored and $php::vars::with_apc
	    and $php::vars::listen_ports['plain'] != false
	    and ($php::vars::munin_apache or $php::vars::munin_nginx)) {
	    if (! defined(Class[Muninnode])) {
		include muninnode
	    }

	    $conf_dir     = $php::vars::munin_conf_dir
	    $listen_ports = $php::vars::listen_ports
	    $web_root     = $php::vars::web_root

	    include common::libs::perllwpua

	    muninnode::define::probe {
		$php::vars::munin_probes:
		    plugin_name => "php_apc_",
		    require     => File["Install php-apc munin probe configuration"];
	    }

	    file {
		"Install php-apc php script":
		    group   => lookup("gid_zero"),
		    mode    => "0644",
		    owner   => root,
		    path    => "$web_root/apc_info.php",
		    require => File["Prepare www directory"],
		    source  => "puppet:///modules/php/apc_info.php";
		"Install php-apc munin probe configuration":
		    content => template("php/munin.erb"),
		    group   => lookup("gid_zero"),
		    mode    => "0644",
		    notify  => Service[$php::vars::munin_service_name],
		    owner   => root,
		    path    => "$conf_dir/plugin-conf.d/php-apc.conf",
		    require => File["Prepare Munin-node plugin-conf directory"];
	    }

	    Class[Common::Libs::Perllwpua]
		-> File["Install php-apc munin probe configuration"]
	} else {
	    muninnode::define::probe {
		$php::vars::munin_probes:
		    status => "absent";
	    }
	}
    }
}
