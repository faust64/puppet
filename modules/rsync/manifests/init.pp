class rsync {
    include rsync::vars

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include rsync::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
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
