class subversion {
    include subversion::vars

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include subversion::redHat
	}
	"Debian", "Devuan", "Ubuntu": {
	    include subversion::debian
	}
	"FreeBSD": {
	    include subversion::freebsd
	}
	"OpenBSD": {
	    include subversion::openbsd
	}
	default: {
	    common::define::patchneeded { "subversion": }
	}
    }

    include subversion::scripts

    if ($subversion::vars::web_front == true) {
	include subversion::webapp
	include subversion::webscripts
    }
}
