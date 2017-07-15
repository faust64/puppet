class common::physical::munin {
    include muninnode

    $smart_disks = lookup("nagios_smart_disks")
    $smart_temp  = lookup("munin_smart_temp")

    if ($smart_disks) {
	include sudo

	$munin_conf_dir = lookup("munin_conf_dir")

	file {
	    "Install Smart munin-node configuration":
		group   => lookup("gid_zero"),
		mode    => "0644",
		notify  => Service[lookup("munin_node_service_name")],
		owner   => root,
		path    => "$munin_conf_dir/plugin-conf.d/smart.conf",
		require => File["Prepare Munin-node plugin-conf directory"],
		source  => "puppet:///modules/common/munin_smart.conf";
	}

	each($smart_disks) |$disk| {
	    muninnode::define::probe {
		"smart_$disk":
		    plugin_name => "smart_",
		    require     => File["Install Smart munin-node configuration"];
	    }

	    Package["smartmontools"]
		-> Muninnode::Define::Probe["smart_$disk"]
	}

	if ($smart_temp) {
	    muninnode::define::probe { "hddtemp_smartctl": }
	} else {
	    muninnode::define::probe {
		"hddtemp_smartctl":
		    status => "absent";
	    }
	}
    }
}
