class cups {
    include cups::vars

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include cups::debian
	}
	"FreeBSD": {
	    include cups::freebsd
	}
	default: {
	    common::define::patchneeded { "cups": }
	}
    }

    include cups::config
    include cups::filetraq
    include cups::nagios
    include cups::service

    if ($kernel == "Linux") {
	include cups::logrotate
    }
    if ($cups::vars::cups_rsyslog == true) {
	include cups::rsyslog
    }
}
