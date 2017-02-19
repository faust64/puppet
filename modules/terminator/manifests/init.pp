class terminator {
    include terminator::vars

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include terminator::debian
	}
	default: {
	    common::define::patchneeded { "terminator": }
	}
    }

    include terminator::config
}
