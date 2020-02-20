class sudo {
    include sudo::vars

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include sudo::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include sudo::debian
	}
	"FreeBSD": {
	    include sudo::freebsd
	}
	"OpenBSD": {
	    include sudo::openbsd
	}
    }

    include sudo::config
    include sudo::filetraq
}
