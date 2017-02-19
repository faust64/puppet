class mysysctl::define::ifqmaxlen {
    $maxlen = hiera("ifqmaxlen")

    case $operatingsystem {
	"FreeBSD": {
	    $sysctl_id = "net.link.ifqmaxlen"
	    $target    = "/boot/loader.conf"

	    File["Ensure /boot/loader.conf exists"]
		-> Common::Define::Lined["Setting IFQ Max Len"]
	}
	"OpenBSD": {
	    $sysctl_id = "net.inet.ip.ifq.maxlen"
	    $target    = "/etc/sysctl.conf"
	}
	default: {
	    $sysctl_id = false
	}
    }

    if ($sysctl_id) {
	if ($target != "/boot/loader.conf") {
	    common::define::lined {
		"Setting IFQ Max Len":
		    line    => "$sysctl_id=$maxlen",
		    match   => "$sysctl_id",
		    notify  => Exec["Apply IFQ Max Len"],
		    path    => $target,
		    require => File["Ensure sysctl.conf present"];
	    }

	    exec {
		"Apply IFQ Max Len":
		    command     => "sysctl $sysctl_id=$maxlen",
		    cwd         => "/",
		    path        => "/sbin",
		    refreshonly => true;
	    }
	} else {
	    common::define::lined {
		"Setting IFQ Max Len":
		    line    => "$sysctl_id=$maxlen",
		    match   => "$sysctl_id",
		    path    => $target,
		    require => File["Ensure sysctl.conf present"];
	    }
	}
    }
}
