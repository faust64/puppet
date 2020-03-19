class python {
    include python::vars

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include python::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
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
