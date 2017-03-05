class nsd {
    include nsd::vars

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include nsd::debian
	}
	"OpenBSD": {
	    include nsd::openbsd
	}
	default: {
	    common::define::patchneeded { "nsd": }
	}
    }

    include nsd::config
    include nsd::control
    include nsd::scripts
    include nsd::service
    include nsd::zones
}
