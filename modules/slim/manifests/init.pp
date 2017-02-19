class slim($window_manager = "openbox") {
    include slim::vars

    case $operatingsystem {
	"CentOS", "RedHat": {
	    include slim::rhel
	}
	"Debian", "Ubuntu": {
	    include slim::debian
	}
	"FreeBSD": {
	    include slim::freebsd
	}
	"OpenBSD": {
	    include slim::openbsd
	}
	default: {
	    common::define::patchneeded { "slim": }
	}
    }

    include slim::config
}
