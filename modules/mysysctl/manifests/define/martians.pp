class mysysctl::define::martians($do_martians = hiera("do_martians")) {
    if ($do_martians == true) {
	$val = "1"
    } else {
	$val = "0"
    }

    case $operatingsystem {
	"CentOS", "Debian", "RedHat", "Ubuntu": {
	    $sysctl_all     = "net.ipv4.conf.all.log_martians"
	    $sysctl_default = "net.ipv4.conf.default.log_martians"
	}
	default: {
	    $sysctl_all     = false
	    $sysctl_default = false
	}
    }

    if ($sysctl_all) {
	common::define::lined {
	    "Enable all.log_martians":
		line    => "$sysctl_all=$val",
		match   => "^$sysctl_all",
		notify  => Exec["Apply all.log_martians"],
		path    => "/etc/sysctl.conf",
		require => File["Ensure sysctl.conf present"];
	    "Enable default.log_martians":
		line    => "$sysctl_default=$val",
		match   => "^$sysctl_default",
		notify  => Exec["Apply default.log_martians"],
		path    => "/etc/sysctl.conf",
		require => File["Ensure sysctl.conf present"];
	}

	exec {
	    "Apply all.log_martians":
		command     => "sysctl $sysctl_all=$val",
		cwd         => "/",
		path        => "/sbin",
		refreshonly => true;
	    "Apply default.log_martians":
		command     => "sysctl $sysctl_default=$val",
		cwd         => "/",
		path        => "/sbin",
		refreshonly => true;
	}
    }
}
