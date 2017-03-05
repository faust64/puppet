class xorg {
    include xorg::vars

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include xorg::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include xorg::debian
	}
	"FreeBSD": {
	    include xorg::freebsd
	}
	"OpenBSD": { }
	default: {
	    common::define::patchneeded { "xorg": }
	}
    }

    include xorg::config
}
