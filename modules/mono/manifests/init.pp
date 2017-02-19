class mono {
    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include mono::debian
	}
	default: {
	    common::define::patchneeded { "mono": }
	}
    }
}
