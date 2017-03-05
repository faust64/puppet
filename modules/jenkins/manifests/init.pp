class jenkins {
    include jenkins::vars

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include jenkins::debian
	}
	default: {
	    common::define::patchneeded { "jenkins": }
	}
    }

    include jenkins::service
}
