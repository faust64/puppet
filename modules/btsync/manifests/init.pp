class btsync {
    include btsync::vars

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include btsync::debian
	}
	default: {
	    common::define::patchneeded { "btsync": }
	}
    }

    include btsync::config
    include btsync::service
}
