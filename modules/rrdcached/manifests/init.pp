class rrdcached {
    include rrdcached::vars

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include rrdcached::debian
	}
	default: {
	    common::define::patchneeded { "rrdcached": }
	}
    }

    include rrdcached::config
    include rrdcached::service
}
