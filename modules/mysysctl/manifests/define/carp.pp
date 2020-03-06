class mysysctl::define::carp {
    if (lookup("carp_do_preempt") == true) {
	$carp_preempt = 1
    } else {
	$carp_preempt = 0
    }

    case $operatingsystem {
	"FreeBSD", "OpenBSD": {
	    common::define::lined {
		"Set CARP log verbosity":
		    line    => "net.inet.carp.log=3",
		    match   => "^net\.inet\.carp\.log",
		    notify  => Exec["Apply CARP log verbosity"],
		    path    => "/etc/sysctl.conf",
		    require => File["Ensure sysctl.conf present"];
		"Allow CARP":
		    line    => "net.inet.carp.allow=1",
		    match   => "^net\.inet\.carp\.allow",
		    notify  => Exec["Apply Allow CARP"],
		    path    => "/etc/sysctl.conf",
		    require => File["Ensure sysctl.conf present"];
		"Set CARP Preempt":
		    line    => "net.inet.carp.preempt=$carp_preempt",
		    match   => "^net\.inet\.carp\.preempt",
		    notify  => Exec["Apply CARP Preempt"],
		    path    => "/etc/sysctl.conf",
		    require => File["Ensure sysctl.conf present"];
	    }

	    exec {
		"Apply CARP log verbosity":
		    command     => "sysctl net.inet.carp.log=3",
		    cwd         => "/",
		    path        => "/sbin",
		    refreshonly => true;
		"Apply Allow CARP":
		    command     => "sysctl net.inet.carp.allow=1",
		    cwd         => "/",
		    path        => "/sbin",
		    refreshonly => true;
		"Apply CARP Preempt":
		    command     => "sysctl net.inet.carp.preempt=$carp_preempt",
		    cwd         => "/",
		    path        => "/sbin",
		    refreshonly => true;
	    }
	}
    }
}
