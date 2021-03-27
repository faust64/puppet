class common::config::ntp {
    $method     = lookup("ntp_method")
    $driftfile  = lookup("ntp_driftfile")
    $minute     = lookup("ntp_update_minute")
    $upstream   = lookup("ntp_upstream")

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    if ($operatingsystemmajrelease == "8" or $operatingsystemmajrelease == 8) {
		$command = false
		$ntpflavor = "chrony"
	    } else {
		$command = "/usr/sbin/ntpdate"
		$ntpflavor = "ntp"
	    }
	    common::define::package {
		"$ntpflavor":
	    }


	    Package["$ntpflavor"]
		-> File["Install ntp default configuration"]
	}
	"Debian", "Devuan", "Ubuntu": {
	    common::define::package {
		"ntp":
	    }

	    $command = "/usr/sbin/ntpdate"
	    $ntpflavor = "ntp"

	    Package["ntp"]
		-> File["Install ntp default configuration"]
	}
	"FreeBSD": {
	    $command = "/usr/sbin/ntpdate"
	    $ntpflavor = "ntp"
	}
	"OpenBSD": {
	    $command = "/usr/sbin/rdate -n"
	    $ntpflavor = "ntp"
	}
	default: {
	    common::define::patchneeded { "common-ntp": }
	}
    }

    if ($command and $upstream != $fqdn) {
	if ($command) {
	    if ($operatingsystem != "OpenBSD") {
		File["Install ntp default configuration"]
		    -> Cron["Sync System Clock"]
	    }

	    cron {
		"Sync System Clock":
		    command => "$command $upstream >/dev/null 2>&1",
		    hour    => "*/4",
		    minute  => $minute,
		    user    => root;
	    }
	}
    } elsif ($upstream == $fqdn) {
	nagios::define::probe {
	    "ntpq":
		description   => "$fqdn NTP sync",
		servicegroups => "system";
	}
    }

    if ($operatingsystem != "OpenBSD") {
	file {
	    "Install ntp default configuration":
		content => template("common/$ntpflavor.erb"),
		group   => lookup("gid_zero"),
		mode    => "0644",
		owner   => root,
		path    => "/etc/$ntpflavor.conf";
	}
    }
}
