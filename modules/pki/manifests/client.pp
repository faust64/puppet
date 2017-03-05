class pki::client {
    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include pki::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include pki::debian
	}
	"FreeBSD": {
	    include pki::freebsd
	}
	"OpenBSD": {
	    include pki::openbsd
	}
	default: {
	    common::define::patchneeded { "pki": }
	}
    }
}
