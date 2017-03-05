class nitrogen {
    include nitrogen::vars

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include nitrogen::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include nitrogen::debian
	}
	"FreeBSD": {
	    include nitrogen::freebsd
	}
	"OpenBSD": {
	    include nitrogen::openbsd
	}
	default: {
	    common::define::patchneeded { "nitrogen": }
	}
    }

    include nitrogen::config
}
