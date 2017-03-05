class lightdm {
    include lightdm::vars

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include lightdm::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include lightdm::debian
	}
	"FreeBSD": {
	    include lightdm::freebsd
	}
	"OpenBSD": {
	    include lightdm::openbsd
	}
	default: {
	    common::define::patchneeded { "lightdm": }
	}
    }

    include lightdm::config
    include lightdm::service
}
