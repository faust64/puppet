class common::config::motd {
    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    $showarch    = $architecture
	    $showversion = $operatingsystemrelease
	}
	"Debian", "Devuan", "Ubuntu": {
	    $showarch    = $hardwaremodel
	    $showversion = $lsbdistcodename
	}
	"FreeBSD", "OpenBSD": {
	    $showarch    = $hardwaremodel
	    $showversion = $kernelrelease
	}
	default: {
	    $showarch    = $hardwaremodel
	    $showversion = "-"
	}
    }

    file {
	"Install system motd":
	    content => template("common/motd.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/motd";
    }

    if ($operatingsystem == "FreeBSD") {
	file {
	    "Install motd updater rc script":
		group  => lookup("gid_zero"),
		mode   => "0555",
		owner  => root,
		path   => "/etc/rc.d/motd",
		source => "puppet:///modules/common/fbsd/rcmotd";
	}
    }
}
