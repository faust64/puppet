class mysysctl::define::carp {
    case $operatingsystem {
	"FreeBSD", "OpenBSD": {
	    file_line {
		"Set CARP log verbosity":
		    line    => "net.inet.carp.log=3",
		    notify  => Exec["Apply CARP log verbosity"],
		    path    => "/etc/sysctl.conf",
		    require => File["Ensure sysctl.conf present"];
		"Allow CARP":
		    line    => "net.inet.carp.allow=1",
		    notify  => Exec["Apply Allow CARP"],
		    path    => "/etc/sysctl.conf",
		    require => File["Ensure sysctl.conf present"];
		"Set CARP Preempt":
		    line    => "net.inet.carp.preempt=1",
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
		    command     => "sysctl net.inet.carp.preempt=1 sysctl.conf",
		    cwd         => "/",
		    path        => "/sbin",
		    refreshonly => true;
	    }
	}
    }
}
