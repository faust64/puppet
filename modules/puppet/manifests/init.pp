class puppet {
    include puppet::vars

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include puppet::debian
	}
	"OpenBSD": {
	    include puppet::openbsd
	}
    }

    include puppet::config
    include puppet::service
}
