class btsync {
    include btsync::vars

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include btsync::debian
	}
	default: {
	    common::define::patchneeded { "btsync": }
	}
    }

    include btsync::config
    include btsync::service
}
