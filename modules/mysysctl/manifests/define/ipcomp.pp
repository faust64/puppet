class mysysctl::define::ipcomp {
    case $operatingsystem {
	"OpenBSD": {
	    $sysctl_id = "net.inet.ipcomp.enable"
	}
	default: {
	    $sysctl_id = false
	}
    }

    if ($sysctl_id) {
	common::define::lined {
	    "Enableing IPCOMP":
		line    => "$sysctl_id=1",
		match   => "^$sysctl_id",
		notify  => Exec["Enable IPCOMP"],
		path    => "/etc/sysctl.conf",
		require => File["Ensure sysctl.conf present"];
	}

	exec {
	    "Enable IPCOMP":
		command     => "sysctl $sysctl_id=1",
		cwd         => "/",
		path        => "/sbin",
		refreshonly => true;
	}
    }
}
