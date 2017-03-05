class asterisk::munin {
    if ($asterisk::vars::munin_probes) {
	if ($asterisk::vars::munin_monitored) {
	    if (! defined(Class[Muninnode])) {
		include muninnode
	    }

	    $ami_addr = $asterisk::vars::ami_bind_addr
	    $conf_dir = $asterisk::vars::munin_conf_dir
	    $creds    = $asterisk::vars::ami['munin']

	    case $myoperatingsystem {
		"Debian", "Devuan", "Ubuntu": {
		    $dependency = "libnet-telnet-perl"
		}
		"CentOS", "RedHat": {
		    $dependency = "perl-Net-Telnet"
		}
	    }

	    muninnode::define::probe {
		$asterisk::vars::munin_probes:
		    require => File["Install asterisk munin probe configuration"];
	    }

	    file {
		"Install asterisk munin probe configuration":
		    content => template("asterisk/munin.erb"),
		    group   => hiera("gid_zero"),
		    mode    => "0644",
		    notify  => Service[$asterisk::vars::munin_service_name],
		    owner   => root,
		    path    => "$conf_dir/plugin-conf.d/asterisk.conf",
		    require => File["Prepare Munin-node plugin-conf directory"];
	    }

	    if ($dependency) {
		common::define::package {
		    $dependency:
		}

		Package[$dependency]
		    -> File["Install asterisk munin probe configuration"]
	    }
	} else {
	    muninnode::define::probe {
		$asterisk::vars::munin_probes:
		    status => "absent";
	    }
	}
    }
}
