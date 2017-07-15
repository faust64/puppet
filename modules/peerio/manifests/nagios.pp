class peerio::nagios {
    $nagios_user  = $peerio::vars::nagios_runtime_user
    $plugindir    = $peerio::vars::nagios_plugins_dir
    $runtime_user = $peerio::vars::runtime_user
    $sudo_conf_d  = $peerio::vars::sudo_conf_dir

    file {
	"Install Peerio Nagios sudoers configuration":
	    content => template("peerio/nagios.sudoers.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0440",
	    owner   => root,
	    path    => "$sudo_conf_d/sudoers.d/nagios-peerio",
	    require => File["Prepare sudo for further configuration"];
    }

    each($peerio::vars::workers) |$worker| {
	nagios::define::probe {
	    "pm2_$worker":
		description   => "$fqdn $worker peerio worker",
		pluginargs    => [ "-u", $runtime_user, "-n", $worker ],
		pluginconf    => "peeriopm2",
		servicegroups => "webservices",
		require       => File["Install Peerio Nagios sudoers configuration"],
		use           => "critical-service";
	}

	$servicename = $worker ? {
		"admin"      => "server",
		"background" => "server",
		"foreground" => "server",
		"filemgr"    => "server",
		"schedule"   => "server",
		default      => $worker
	    }

	if (! defined(Nagios::Define::Probe["runtime_$servicename"])) {
	    nagios::define::probe {
		"runtime_$servicename":
		    description   => "$fqdn peerio-$servicename runtime copy",
		    pluginargs    => [ $servicename ],
		    pluginconf    => "peerioruntime",
		    servicegroups => "webservices",
		    require       => File["Install Peerio Nagios sudoers configuration"],
		    use           => "jobs-service";
	    }
	}
    }
}
