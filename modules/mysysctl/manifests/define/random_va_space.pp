class mysysctl::define::random_va_space {
    case $myoperatingsystem {
	"CentOS", "Debian", "Devuan", "RedHat", "Ubuntu": {
	    $sysctl_id = "kernel.randomize_va_space"
	}
	default: {
	    $sysctl_id = false
	}
    }

    if ($sysctl_id) {
	common::define::lined {
	    "Randomize virtual memory placement":
		line    => "$sysctl_id=2",
		match   => "^$sysctl_id",
		notify  => Exec["Apply vmem placement randomization"],
		path    => "/etc/sysctl.conf",
		require => File["Ensure sysctl.conf present"];
	}

	exec {
	    "Apply vmem placement randomization":
		command     => "sysctl $sysctl_id=2",
		cwd         => "/",
		path        => "/sbin",
		refreshonly => true;
	}
    }
}
