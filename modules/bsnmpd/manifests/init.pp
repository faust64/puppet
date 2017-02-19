class bsnmpd {
    include bsnmpd::vars
    include common::libs::snmp

    case $operatingsystem {
	"FreeBSD": {
	    include bsnmpd::freebsd
	}
	default: {
	    common::define::patchneeded { "bsnmpd": }
	}
    }

    include bsnmpd::config
    include bsnmpd::service
}
