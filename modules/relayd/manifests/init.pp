class relayd {
    include relayd::vars

    case $operatingsystem {
	"FreeBSD": {
	    include relayd::freebsd
	}
	"OpenBSD": {
	    include relayd::openbsd
	}
    }

    include relayd::config
    include relayd::service
    include relayd::nagios
}
