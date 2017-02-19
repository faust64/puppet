class common::physical::nagios {
    $smart_disks = hiera("nagios_smart_disks")
    $lm_sensors  = hiera("has_lm_sensors")

    if ($lm_sensors) {
	nagios::define::probe {
	    "sensors":
		description   => "$fqdn sensors",
		servicegroups => "system";
	}
    }

    if ($smart_disks) {
	include sudo
	include common::libs::perlconfigjson

	$nagios_user = hiera("nagios_runtime_user")
	$plugindir   = hiera("nagios_plugins_dir")
	$sudo_conf_d = hiera("sudo_conf_dir")

	file {
	    "Add nagios user to sudoers for smartmontools":
		content => template("common/smartmontools.sudoers.erb"),
		group   => hiera("gid_zero"),
		mode    => "0440",
		owner   => root,
		path    => "$sudo_conf_d/sudoers.d/nagios-smartmontools",
		require => File["Prepare sudo for further configuration"];
	}

	each($smart_disks) |$disk| {
	    nagios::define::probe {
		"smart_$disk":
		    pluginargs    => [ "/dev/$disk" ],
		    pluginconf    => "smart",
		    description   => "$fqdn SMART $disk",
		    servicegroups => "system",
		    use           => "jobs-service";
	    }

	    Package["smartmontools"]
		-> File["Add nagios user to sudoers for smartmontools"]
		-> Nagios::Define::Probe["smart_$disk"]
	}
    }
}
