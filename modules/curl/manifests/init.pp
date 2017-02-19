class curl {
    case $operatingsystem {
	"CentOS", "RedHat": {
	    include curl::rhel
	}
	"Debian", "Ubuntu": {
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
