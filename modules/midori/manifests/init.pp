class midori {
    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include midori::debian
	}
	"FreeBSD": {
	    include midori::freebsd
	}
	"OpenBSD": {
	    include midori::openbsd
	}
	default: {
	    common::define::patchneeded { "midori": }
	}
    }

    include sqlite
}
