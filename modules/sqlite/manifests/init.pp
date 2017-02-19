class sqlite {
    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include sqlite::debian
	}
	default: {
	    common::define::patchneeded { "sqlite": }
	}
    }
}
