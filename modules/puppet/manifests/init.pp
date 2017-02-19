class puppet {
    include puppet::vars

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include puppet::debian
	}
	"OpenBSD": {
	    include puppet::openbsd
	}
    }

    include puppet::config
    include puppet::service
}
