class common::config::mail {
    if (hiera("postfix_routeto") == $fqdn) {
	include bluemind
    } else {
	case $operatingsystem {
	    "Debian", "CentOS", "RedHat", "Ubuntu": {
		include postfix
	    }
	    "FreeBSD": {
		include sendmail
	    }
	    "OpenBSD": {
		include opensmtpd
	    }
	    default: {
		common::define::patchneeded { "common-mail": }
	    }
	}
    }

    if ($srvtype == "mail") {
	$target = $fqdn
    } else {
	$target = "127.0.0.1"
    }

    if ($operatingsystem != "OpenBSD") {
	nagios::define::probe {
	    "mailq":
		description   => "$fqdn mailq",
		pluginargs    => [ "-w 20 -c 50" ],
		use           => "critical-service";
	}
    }

    nagios::define::probe {
	"smtp":
	    description   => "$fqdn smtp",
	    pluginargs    =>
		[
		    "-H $target",
		    "-p 25"
		],
	    servicegroups => "netservices";
    }
}
