class pki::client {
    case $operatingsystem {
	"CentOS", "RedHat": {
	    include pki::rhel
	}
	"Debian", "Ubuntu": {
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
