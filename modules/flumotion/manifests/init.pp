class flumotion {
    include flumotion::vars

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include flumotion::debian
	}
	default: {
	    common::define::patchneeded { "flumotion": }
	}
    }

    include flumotion::config
    include flumotion::service
}
