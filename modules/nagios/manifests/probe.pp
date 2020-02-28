class nagios::probe {
    $hpraid      = $nagios::vars::watch_hpraid
    $mdraid      = $nagios::vars::watch_mdraid
    $nagios_user = $nagios::vars::runtime_user

    if ($virtual == "physical" or $virtual == "xen0" or $virtual == "openvzhn") {
	include sudo

	$dmidecode   = $nagios::vars::dmidecode_bin
	$ipmitool    = $nagios::vars::ipmitool_bin
	$sudo_conf_d = $nagios::vars::sudo_conf_dir

	file {
	    "Add nagios user to sudoers for hwinfos querying":
		content => template("nagios/nagios.sudoers.erb"),
		group   => lookup("gid_zero"),
		mode    => "0440",
		owner   => root,
		path    => "$sudo_conf_d/sudoers.d/nagios-hwutils",
		require => File["Prepare sudo for further configuration"];
	}
    }

    if ($nagios::vars::parents) {
	@@nagios_host {
	    $fqdn:
		address         => $nagios::vars::remoteaddr,
		alias           => $fqdn,
		contacts        => "root",
		hostgroups      => $nagios::vars::nagios_hostgroup,
		icon_image      => $nagios::vars::iconimage,
		icon_image_alt  => $nagios::vars::iconimagealt,
		notify          => Exec["Refresh Icinga configuration"],
		parents         => $nagios::vars::parents,
		require         => File["Prepare nagios hosts probes import directory"],
		statusmap_image => $nagios::vars::statusmapimage,
		tag             => "nagios-$domain",
		target          => "/etc/nagios/import.d/hosts/$fqdn.cfg",
		use             => $nagios::vars::nagios_class;
	}

	each($nagios::vars::parents.split(',')) |$hooker| {
	    nagios::define::host_dependencies{ $hooker: }
	}
    } else {
	@@nagios_host {
	    $fqdn:
		address         => $nagios::vars::remoteaddr,
		alias           => $fqdn,
		contacts        => "root",
		hostgroups      => $nagios::vars::nagios_hostgroup,
		icon_image      => $nagios::vars::iconimage,
		icon_image_alt  => $nagios::vars::iconimagealt,
		notify          => Exec["Refresh Icinga configuration"],
		require         => File["Prepare nagios hosts probes import directory"],
		statusmap_image => $nagios::vars::statusmapimage,
		tag             => "nagios-$domain",
		target          => "/etc/nagios/import.d/hosts/$fqdn.cfg",
		use             => $nagios::vars::nagios_class;
	}
    }

    nagios::define::probe {
	"alive":
	    command        => "check-host-alive",
	    dependency     => false,
	    description    => "$fqdn alive",
	    escalate_itv   => 15,
	    escalate_last  => 20,
	    is_nrpe        => false,
	    servicegroups  => "network",
	    use            => "critical-service";
	"fdesc":
	    description    => "$fqdn opened files",
	    escalate_first => 5,
	    escalate_itv   => 5,
	    escalate_last  => 8,
	    servicegroups  => "system",
	    use            => "critical-service";
	"dns":
	    description    => "$fqdn ability to resolve public names",
	    pluginargs     => [ "-H", $nagios::vars::dns_proof ],
	    servicegroups  => "dns",
	    use            => "critical-service";
	"load":
	    description    => "$fqdn load",
	    escalate_first => 5,
	    escalate_itv   => 5,
	    escalate_last  => 8,
	    pluginargs     =>
		[
		    "-w", $nagios::vars::nagios_load_warn,
		    "-c", $nagios::vars::nagios_load_crit
		],
	    servicegroups  => "system",
	    use            => "critical-service";
	"nrpe_available":
	    dependency     => "$fqdn alive",
	    description    => "$fqdn NRPE service",
	    escalate_first => 2,
	    escalate_itv   => 3,
	    escalate_last  => 5,
	    pluginconf     => false,
	    servicegroups  => "system",
	    use            => "jobs-service";
	"nsdec":
	    dependency     => false,
	    description    => "$fqdn DNS record",
	    escalate_itv   => 15,
	    escalate_last  => 20,
	    is_nrpe        => false,
	    servicegroups  => "dns",
	    use            => "jobs-service";
	"nsrev":
	    dependency     => false,
	    description    => "$fqdn DNS reverse record",
	    escalate_itv   => 15,
	    escalate_last  => 20,
	    is_nrpe        => false,
	    servicegroups  => "dns",
	    use            => "jobs-service";
	"procs":
	    description    => "$fqdn processes",
	    escalate_first => 2,
	    escalate_itv   => 10,
	    escalate_last  => 7,
	    pluginargs     =>
		[
		    "-w", $nagios::vars::procs_warn,
		    "-c", $nagios::vars::procs_crit
		],
	    servicegroups  => "system",
	    use            => "error-service";
	"rprocs":
	    description    => "$fqdn running processes",
	    escalate_first => 2,
	    escalate_itv   => 10,
	    escalate_last  => 7,
	    pluginargs     =>
		[
		    "-w", $nagios::vars::runprocs_warn,
		    "-c", $nagios::vars::runprocs_crit
		],
	    servicegroups  => "system",
	    use            => "error-service";
	"ssh":
	    description    => "$fqdn ssh",
	    escalate_first => 5,
	    escalate_itv   => 2,
	    escalate_last  => 6,
	    pluginargs     => [ "-p", $nagios::vars::ssh_port, "127.0.0.1" ],
	    servicegroups  => "netservices",
	    use            => "error-service";
	"uptime":
	    description    => "$fqdn uptime",
	    escalate_first => 20,
	    escalate_itv   => 60,
	    escalate_last  => 21,
	    servicegroups  => "system",
	    use            => "jobs-service";
	"users":
	    description    => "$fqdn connected users",
	    escalate_itv   => 5,
	    escalate_last  => 3,
	    pluginargs     =>
		[
		    "-w", $nagios::vars::users_warn,
		    "-c", $nagios::vars::users_crit
		],
	    servicegroups  => "system",
	    use            => "warning-service";
    }

    if ($nagios::vars::watchlist == false) {
	nagios::define::watchdisk {
	    "root":
	}
    } else {
	each($nagios::vars::watchlist) |$disk, $partition| {
	    if (! defined(Nagios::Define::Watchdisk[$disk])) {
		nagios::define::watchdisk {
		    $disk:
		}
	    }
	}
    }
    if ($nagios::vars::tmpdev or $kernel == "Linux") {
	if (! defined(Nagios::Define::Watchdisk["tmp"])) {
	    nagios::define::watchdisk {
		"tmp":
	    }
	}
    }
    if ($hpraid) {
	each($hpraid) |$disk| {
	    nagios::define::watch_hpraid {
		$disk:
	    }
	}
    }
    if ($mdraid) {
	each($mdraid) |$disk| {
	    nagios::define::watch_mdraid {
		$disk:
	    }
	}
    }

    if ($kernel == "Linux" and ($virtual == "physical" or $virtual == "xen0" or $virtual == "openvzhn")) {
	$sudo_conf_dir = $nagios::vars::sudo_conf_dir

	file {
	    "Install nagios tune2fs sudoers configuration":
		content => template("nagios/sudoers.erb"),
		group   => lookup("gid_zero"),
		mode    => "0440",
		owner   => root,
		path    => "$sudo_conf_dir/sudoers.d/nagios-tune2fs",
		require => File["Prepare sudo for further configuration"];
	}

	nagios::define::probe {
	    "fsck":
		description   => "$fqdn ext FS status",
		escalate_itv  => 1440,
		servicegroups => "system",
		require       => File["Install nagios tune2fs sudoers configuration"],
		use           => "jobs-service";
	}
    }

    if (getvar('::swapsize')) {
	if ($swapsize =~ /[1-9]/) {
	    $swapensure = "present"
	} else { $swapensure = "absent" }
    } else { $swapensure = "absent" }

    nagios::define::probe {
	"swap":
	    description   => "$fqdn swap usage",
	    ensure        => $swapensure,
	    escalate_itv  => 10,
	    escalate_last => 6,
	    pluginconf    => "swap",
	    servicegroups => "system",
	    use           => "critical-service";
    }

    if ($virtual == "physical" or $virtual == "xen0" or $virtual == "openvzhn") {
	nagios::define::probe {
	    "mem":
		description   => "$fqdn RAM usage",
		servicegroups => "system",
		use           => "critical-service";
	}

	if ($architecture == "amd64" or $architecture == "x86_64"
	    or $architecture == "i386" or $architecture == "ia64") {
	    nagios::define::probe {
		"hwstatus":
		    description   => "$fqdn hardware status",
		    escalate_itv  => 1440,
		    escalate_last => 3,
		    servicegroups => "system",
		    use           => "status-service";
	    }
	}
    }

    if ($nagios::vars::jumbo_check) {
	if ($nagios::vars::jumbo_check != true) {
	    $netif = $nagios::vars::jumbo_check
	} else {
	    $netif = $interfaces.split(',')[0]
	}
	nagios::define::probe {
	    "mtu":
		pluginargs    => [ "-i", $netif ],
		description   => "$fqdn mtu on $netif",
		escalate_itv  => 1440,
		escalate_last => 3,
		servicegroups => "system",
		use           => "jobs-service";
	}
    }
}
