class chromium {
    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include chromium::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include chromium::debian
	}
	"FreeBSD": {
	    include chromium::freebsd
	}
	"OpenBSD": {
	    include chromium::openbsd
	}
	default: {
	    common::define::patchneeded { "chromium": }
	}
    }
}
