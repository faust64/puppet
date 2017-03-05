class curl {
    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include curl::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include curl::debian
	}
	"FreeBSD": {
	    include curl::freebsd
	}
	"OpenBSD": {
	    include curl::openbsd
	}
	default: {
	    common::define::patchneeded { "curl": }
	}
    }

    include curl::config
}
