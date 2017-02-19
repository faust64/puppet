class dhcrelay {
    include dhcrelay::vars

    case $operatingsystem {
	"OpenBSD": {
	    include dhcrelay::openbsd
	}
	default: {
	    common::define::patchneeded { "dhcrelay": }
	}
    }

    include dhcrelay::service
}
