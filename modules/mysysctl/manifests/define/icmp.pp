class mysysctl::define::icmp {
    case $operatingsystem {
	"CentOS", "Debian", "RedHat", "Ubuntu": {
	    $bcast_id = "net.ipv4.icmp_echo_ignore_broadcasts"
	    $bogus_id = "net.ipv4.icmp_ignore_bogus_error_responses"
	}
	default: {
	    $bcast_id = false
	    $bogus_id = false
	}
    }

    if ($bcast_id) {
	common::define::lined {
	    "Set $bcast_id":
		line    => "$bcast_id=1",
		match   => "^$bcast_id",
		notify  => Exec["Apply $bcast_id"],
		path    => "/etc/sysctl.conf",
		require => File["Ensure sysctl.conf present"];
	}

	exec {
	    "Apply $bcast_id":
		command     => "sysctl $bcast_id=1",
		cwd         => "/",
		path        => "/sbin",
		refreshonly => true;
	}
    }
    if ($bogus_id) {
	common::define::lined {
	    "Set $bogus_id":
		line    => "$bogus_id=1",
		match   => "^$bogus_id",
		notify  => Exec["Apply $bogus_id"],
		path    => "/etc/sysctl.conf",
		require => File["Ensure sysctl.conf present"];
	}

	exec {
	    "Apply $bogus_id":
		command     => "sysctl $bogus_id=1",
		cwd         => "/",
		path        => "/sbin",
		refreshonly => true;
	}
    }
}
