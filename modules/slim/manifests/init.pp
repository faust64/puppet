class slim($window_manager = "openbox") {
    include slim::vars

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include slim::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
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
