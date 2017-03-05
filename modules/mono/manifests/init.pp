class mono {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include mono::debian
	}
	default: {
	    common::define::patchneeded { "mono": }
	}
    }
}
