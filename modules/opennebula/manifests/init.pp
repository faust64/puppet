class opennebula {
    include opennebula::vars

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include opennebula::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include opennebula::debian
	}
	default: {
	    common::define::patchneeded { "opennebula": }
	}
    }

    if ($srvtype == "opennebula" and $opennebula::vars::controller != false) {
	include opennebula::compute
    } else {
	if ($opennebula::vars::do_controller) {
	    include opennebula::controller
	    include opennebula::nagios
	}
	if ($opennebula::vars::do_oneflow) {
	    include opennebula::oneflow
	}
	if ($opennebula::vars::do_onegate) {
	    include opennebula::onegate
	}
	if ($opennebula::vars::do_sunstone) {
	    include opennebula::sunstone
	}
	include opennebula::service
    }
}
