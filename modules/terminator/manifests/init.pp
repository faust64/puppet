class terminator {
    include terminator::vars

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include terminator::debian
	}
	default: {
	    common::define::patchneeded { "terminator": }
	}
    }

    include terminator::config
}
