class bgpd {
    include bgpd::vars
    include bgpd::scripts

    case $operatingsystem {
	"OpenBSD": {
	    include bgpd::openbsd
	}
	default: {
	    common::define::patchneeded { "bgpd": }
	}
    }

    include bgpd::config
    include bgpd::nagios
    include bgpd::service
}
