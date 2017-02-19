class python {
    case $operatingsystem {
	"CentOS", "RedHat": {
	    include python::rhel
	}
	"Debian", "Ubuntu": {
	    include python::debian
	}
	"FreeBSD": {
	    include python::freebsd
	}
	"OpenBSD": {
	    include python::openbsd
	}
	default: {
	    common::define::patchneeded { "python": }
	}
    }
}
