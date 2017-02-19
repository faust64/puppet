class rsync {
    include rsync::vars

    case $operatingsystem {
	"CentOS", "RedHat": {
	    include rsync::rhel
	}
	"Debian", "Ubuntu": {
	    include rsync::debian
	}
	"FreeBSD": {
	    include rsync::freebsd
	}
	"OpenBSD": {
	    include rsync::openbsd
	}
	default: {
	    common::define::patchneeded { "rsync": }
	}
    }

    include rsync::config
    include rsync::service
}
