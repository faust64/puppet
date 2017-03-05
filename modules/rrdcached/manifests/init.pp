class rrdcached {
    include rrdcached::vars

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include rrdcached::debian
	}
	default: {
	    common::define::patchneeded { "rrdcached": }
	}
    }

    include rrdcached::config
    include rrdcached::service
}
