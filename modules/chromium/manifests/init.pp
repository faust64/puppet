class chromium {
    case $operatingsystem {
	"CentOS", "RedHat": {
	    include chromium::rhel
	}
	"Debian", "Ubuntu": {
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
