class mysysctl::define::ipsec {
    case $operatingsystem {
	"OpenBSD": {
	    $sysctl_id = "net.inet.esp.enable"
	}
	default: {
	    $sysctl_id = false
	}
    }

    if ($sysctl_id) {
	common::define::lined {
	    "Enableing ESP":
		line    => "$sysctl_id=1",
		match   => "^$sysctl_id",
		notify  => Exec["Enable ESP"],
		path    => "/etc/sysctl.conf",
		require => File["Ensure sysctl.conf present"];
	}

	exec {
	    "Enable ESP":
		command     => "sysctl $sysctl_id=1",
		cwd         => "/",
		path        => "/sbin",
		refreshonly => true;
	}
    }
}
