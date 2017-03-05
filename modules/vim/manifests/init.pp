class vim {
    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include vim::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include vim::debian
	}
	"FreeBSD": {
	    include vim::freebsd
	}
	"OpenBSD": {
	    include vim::openbsd
	}
	default: {
	    common::define::patchneeded { "vim": }
	}
    }
    include vim::config
}
