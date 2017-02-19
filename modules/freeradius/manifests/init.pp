class freeradius {
    include freeradius::vars

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include freeradius::debian
	}
	"OpenBSD": {
	    include freeradius::openbsd
	}
	default: {
	    common::define::patchneeded { "freeradius": }
	}
    }
    include freeradius::config
    include freeradius::ssl
    include freeradius::service

    if ($kernel == "Linux") {
	include freeradius::logrotate
    }

    include freeradius::nagios
}
