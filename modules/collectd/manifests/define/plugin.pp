define collectd::define::plugin($source = "$name",
				$status = "present") {
    $conf_dir  = lookup("collectd_conf_dir")
    $web_ports = lookup("apache_listen_ports")

    if ($status == "present") {
	file {
	    "Configure collectd $name plugin":
		content => template("collectd/plugin/$source.erb"),
		group   => lookup("gid_zero"),
		mode    => "0644",
		notify  => Service["collectd"],
		owner   => root,
		path    => "$conf_dir/collectd.d/$name.conf",
		require => File["Prepare collectd plugins configuration directory"];
	}
    } elsif (defined(Service["collectd"])) {
	file {
	    "Configure collectd $name plugin":
		content => template("collectd/plugin/$source.erb"),
		ensure  => absent,
		group   => lookup("gid_zero"),
		mode    => "0644",
		notify  => Service["collectd"],
		owner   => root,
		path    => "$conf_dir/collectd.d/$name.conf",
		require => File["Prepare collectd plugins configuration directory"];
	}
    } elsif (defined(Service["collectd"])) {
	file {
	    "Drop collectd $name plugin":
		ensure  => absent,
		force   => true,
		notify  => Service["collectd"],
		path    => "$conf_dir/collectd.d/$name.conf";
	}
    } else {
	file {
	    "Purge collectd $name plugin":
		ensure  => absent,
		force   => true,
		path    => "$conf_dir/collectd.d/$name.conf";
	}
    }
}
