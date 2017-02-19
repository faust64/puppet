class opennebula {
    include opennebula::vars

    case $operatingsystem {
	"CentOS", "RedHat": {
	    include opennebula::rhel
	}
	"Debian", "Ubuntu": {
	    include opennebula::debian
	}
	default: {
	    common::define::patchneeded { "opennebula": }
	}
    }

    if ($opennebula::vars::nebula_class == "compute"
	and $opennebula::vars::datastore0 != false) {
	include opennebula::compute
    } elsif ($opennebula::vars::nebula_class == "sunstone") {
	include opennebula::sunstone
	include opennebula::nagios
    }
}
