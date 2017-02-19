class jenkins {
    include jenkins::vars

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include jenkins::debian
	}
	default: {
	    common::define::patchneeded { "jenkins": }
	}
    }

    include jenkins::service
}
