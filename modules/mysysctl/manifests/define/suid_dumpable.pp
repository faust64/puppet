class mysysctl::define::suid_dumpable {
    case $operatingsystem {
	"CentOS", "Debian", "RedHat", "Ubuntu": {
	    $sysctl_id = "fs.suid_dumpable"
	}
    }

    if ($sysctl_id) {
	common::define::lined {
	    "Restrict suid bins from being coredumped":
		line    => "$sysctl_id=0",
		match   => "^$sysctl_id",
		notify  => Exec["Apply suid_dumpable restriction"],
		path    => "/etc/sysctl.conf",
		require => File["Ensure sysctl.conf present"];
	}

	exec {
	    "Apply suid_dumpable restriction":
		command     => "sysctl $sysctl_id=0",
		cwd         => "/",
		path        => "/sbin",
		refreshonly => true;
	}
    }
}
