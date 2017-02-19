class xorg {
    include xorg::vars

    case $operatingsystem {
	"CentOS", "RedHat": {
	    include xorg::rhel
	}
	"Debian", "Ubuntu": {
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
