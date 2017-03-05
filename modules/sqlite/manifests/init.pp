class sqlite {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include sqlite::debian
	}
	default: {
	    common::define::patchneeded { "sqlite": }
	}
    }
}
