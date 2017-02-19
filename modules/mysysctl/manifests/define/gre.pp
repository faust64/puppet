class mysysctl::define::gre {
    case $operatingsystem {
	"OpenBSD": {
	    $sysctl_id = "net.inet.gre.allow"
	}
	default: {
	    $sysctl_id = false
	}
    }

    if ($sysctl_id) {
	common::define::lined {
	    "Enableing GRE":
		line    => "$sysctl_id=1",
		match   => "^$sysctl_id",
		notify  => Exec["Enable GRE"],
		path    => "/etc/sysctl.conf",
		require => File["Ensure sysctl.conf present"];
	}

	exec {
	    "Enable GRE":
		command     => "sysctl $sysctl_id=1",
		cwd         => "/",
		path        => "/sbin",
		refreshonly => true;
	}
    }
}
