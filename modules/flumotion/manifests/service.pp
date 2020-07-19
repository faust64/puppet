class flumotion::service {
    if (defined(Class["xorg"])) {
	$rcaction  = "remove"
	$rconlyif  = "test -L /etc/rc.d/S17flumotion"
	$rcunless  = "exit 0"
	$srvstatus = "stopped"
    }
    else {
	$rcaction  = "defaults"
	$rconlyif  = "exit 0"
	$rcunless  = "test -L /etc/rc.d/S17flumotion"
	$srvstatus = "running"
    }

    common::define::service {
	"flumotion":
	    ensure  => $srvstatus,
	    require => Package["flumotion"];
    }

    if ($kernel == "Linux") {
	exec {
	    "Set flumotion service status":
		command => "update-rc.d flumotion $rcaction",
		onlyif  => $rconlyif,
		path    => "/usr/sbin:/sbin:/usr/bin:/bin",
		require => Common::Define::Service["flumotion"],
		unless  => $rcunless;
	}
    }
}
