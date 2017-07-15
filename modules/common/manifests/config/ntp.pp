class common::config::ntp {
    $method     = lookup("ntp_method")
    $driftfile  = lookup("ntp_driftfile")
    $minute     = lookup("ntp_update_minute")
    $upstream   = lookup("ntp_upstream")

    case $myoperatingsystem {
	"CentOS", "Debian", "Devuan", "RedHat", "Ubuntu": {
	    common::define::package {
		"ntp":
	    }

	    $command = "/usr/sbin/ntpdate"

	    Package["ntp"]
		-> File["Install ntp default configuration"]
	}
	"FreeBSD": {
	    $command = "/usr/sbin/ntpdate"
	}
	"OpenBSD": {
	    $command = "/usr/sbin/rdate -n"
	}
	default: {
	    common::define::patchneeded { "common-ntp": }
	}
    }

    if ($command and $upstream != $fqdn) {
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
		content => template("common/ntp.erb"),
		group   => lookup("gid_zero"),
		mode    => "0644",
		owner   => root,
		path    => "/etc/ntp.conf";
	}
    }
}
