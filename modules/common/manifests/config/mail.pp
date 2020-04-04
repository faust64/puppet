class common::config::mail {
    if (lookup("postfix_routeto") == $fqdn) {
	include bluemind
	include postfix::jobs
    } else {
	case $myoperatingsystem {
	    "Debian", "Devuan", "CentOS", "RedHat", "Ubuntu": {
		include postfix
		include postfix::jobs
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

    if ($operatingsystem == "OpenBSD") {
	$mopts = [ "-w 10 -c 30 -M nullmailer" ]
    } else {
	$mopts = [ "-w 20 -c 50" ]
    }

    nagios::define::probe {
	"mailq":
	    description   => "$fqdn mailq",
	    pluginargs    => $mopts,
	    use           => "critical-service";
	"smtp":
	    description   => "$fqdn smtp",
	    pluginargs    =>
		[
		    "-H $target",
		    "-p 25"
		],
	    servicegroups => "netservices",
	    use           => "meh-service";
    }
}
