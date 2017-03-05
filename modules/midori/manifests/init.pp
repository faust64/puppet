class midori {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
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
