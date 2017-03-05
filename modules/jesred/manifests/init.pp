class jesred {
    include jesred::vars

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include jesred::debian
	}
	default: {
	    common::define::patchneeded { "jesred": }
	}
    }

    include jesred::config
}
