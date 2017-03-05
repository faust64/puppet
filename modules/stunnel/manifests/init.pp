class stunnel {
    include stunnel::vars

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include stunnel::debian
	}
	default: {
	    common::define::patchneeded { "stunnel": }
	}
    }

    include stunnel::config
    include stunnel::service
}
