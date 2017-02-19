class isakmpd {
    include isakmpd::vars

    case $operatingsystem {
	"FreeBSD": {
	    include isakmpd::freebsd
	}
	"OpenBSD": {
	    include isakmpd::openbsd
	}
    }

    include isakmpd::config
    include isakmpd::service
    include isakmpd::scripts
    include isakmpd::jobs
    include isakmpd::nagios
}
