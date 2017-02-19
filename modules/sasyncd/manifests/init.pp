class sasyncd {
    include sasyncd::vars

    case $operatingsystem {
	"FreeBSD": {
	    include sasyncd::freebsd
	}
	"OpenBSD": {
	    include sasyncd::openbsd
	}
    }

    include sasyncd::config
    include sasyncd::service
}
