class ipfw {
    include ipfw::vars

    case $operatingsystem {
	"FreeBSD": {
	    include ipfw::freebsd
	}
	default: {
	    common::define::patchneeded { "ipfw": }
	}
    }

    include ipfw::config
    include ipfw::service
}
