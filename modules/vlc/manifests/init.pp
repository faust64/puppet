class vlc {
    include vlc::vars

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include vlc::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include vlc::debian
	}
	"FreeBSD": {
	    include vlc::freebsd
	}
	"OpenBSD": {
	    include vlc::openbsd
	}
	default: {
	    common::define::patchneeded { "vlc": }
	}
    }

    include vlc::config
}
