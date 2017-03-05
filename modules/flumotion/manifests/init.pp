class flumotion {
    include flumotion::vars

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include flumotion::debian
	}
	default: {
	    common::define::patchneeded { "flumotion": }
	}
    }

    include flumotion::config
    include flumotion::service
}
