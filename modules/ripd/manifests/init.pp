class ripd {
    include ripd::vars
    include ripd::scripts

    case $operatingsystem {
	"OpenBSD": {
	    include ripd::openbsd
	}
	default: {
	    common::define::patchneeded { "ripd": }
	}
    }

    include ripd::config
    include ripd::nagios
    include ripd::service
}
