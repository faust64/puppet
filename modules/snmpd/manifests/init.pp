class snmpd {
    include snmpd::vars
    include snmpd::config
    include common::libs::snmp

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include snmpd::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include snmpd::debian
	}
	"FreeBSD": {
	    include bsnmpd
	}
	"OpenBSD": {
	    include snmpd::openbsd
	}
	default: {
	    common::define::patchneeded { "snmpd": }
	}
    }

    include snmpd::service
}
