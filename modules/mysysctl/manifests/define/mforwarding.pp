class mysysctl::define::mforwarding {
    $mforward = hiera("igmp_forwarding")

    case $operatingsystem {
	"OpenBSD": {
	    $forward = "net.inet.ip.mforwarding"
	}
	default: {
	    $forward = false
	}
    }

    if ($forward) {
	common::define::lined {
	    "Set IGMP forwarding":
		line    => "$forward=$mforward",
		match   => "^$forward",
		notify  => Exec["Apply IGMP forwarding"],
		path    => "/etc/sysctl.conf",
		require => File["Ensure sysctl.conf present"];
	}

	exec {
	    "Apply IGMP forwarding":
		command     => "sysctl $forward=$mforward",
		cwd         => "/",
		path        => "/sbin",
		refreshonly => true;
	}
    }
}
