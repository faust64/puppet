class nitrogen {
    include nitrogen::vars

    case $operatingsystem {
	"CentOS", "RedHat": {
	    include nitrogen::rhel
	}
	"Debian", "Ubuntu": {
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
