class docker {
    case $operatingsystem {
	"Debian", "Ubuntu": {
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
