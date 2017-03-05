class docker {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include docker::debian
	}
	default: {
	    common::define::patchneeded { "docker": }
	}
    }

    docker::define::image {
	[ "ubuntu", "debian" ]:
    }
}
