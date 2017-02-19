class stunnel {
    include stunnel::vars

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include stunnel::debian
	}
	default: {
	    common::define::patchneeded { "stunnel": }
	}
    }

    include stunnel::config
    include stunnel::service
}
