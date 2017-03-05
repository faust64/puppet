class squid {
    include squid::vars

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include squid::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include squid::debian
	}
	"OpenBSD": {
	    include squid::openbsd
	}
	default: {
	    common::define::patchneeded { "squid": }
	}
    }

    include squid::config
    include squid::filetraq
    include squid::nagios
    include squid::service

    if ($squid::vars::squid_rsyslog == true) {
	include squid::rsyslog
    }

    if ($kernel == "Linux") {
	include squid::logrotate
    }
}
