class jesred {
    include jesred::vars

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include jesred::debian
	}
	default: {
	    common::define::patchneeded { "jesred": }
	}
    }

    include jesred::config
}
