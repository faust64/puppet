class ospfd {
    include ospfd::vars
    include ospfd::scripts

    case $operatingsystem {
	"FreeBSD": {
	    include ospfd::freebsd
	}
	"OpenBSD": {
	    include ospfd::openbsd
	}
	default: {
	    common::define::patchneeded { "ospfd": }
	}
    }

    include ospfd::config
    include ospfd::nagios
    include ospfd::jobs
    include ospfd::service
}
