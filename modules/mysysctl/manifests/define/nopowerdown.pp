class mysysctl::define::nopowerdown {
    case $operatingsystem {
	"OpenBSD": {
	    $sysctl_id = "hw.allowpowerdown"
	}
	default: {
	    $sysctl_id = false
	}
    }

    if ($sysctl_id) {
	common::define::lined {
	    "Disableing Power Switch":
		line    => "$sysctl_id=0",
		match   => "^$sysctl_id",
		notify  => Exec["Disable Power Switch"],
		path    => "/etc/sysctl.conf",
		require => File["Ensure sysctl.conf present"];
	}

	exec {
	    "Disable Power Switch":
		command     => "sysctl $sysctl_id=0",
		cwd         => "/",
		path        => "/sbin",
		refreshonly => true;
	}
    }
}
