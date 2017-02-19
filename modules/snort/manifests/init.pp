class snort {
    include snort::vars

    case $operatingsystem {
	"OpenBSD": {
	    include snort::openbsd
	}
	default: {
	    common::define::patchneeded { "snort": }
	}
    }

    include snort::config
    include snort::service
}
