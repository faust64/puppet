class icinga {
    include icinga::vars

    case $operatingsystem {
	"CentOS", "RedHat": {
	    include icinga::rhel
	}
	"Debian", "Ubuntu": {
	    include icinga::debian
	}
	default: {
	    common::define::patchneeded { "icinga": }
	}
    }

    include icinga::cleanup
    include icinga::collect
    include icinga::config
    include icinga::configd
    include icinga::contacts
    include icinga::filetraq
    include icinga::hostgroups
    include icinga::import
    include icinga::importd
    include icinga::localchecks
    include icinga::logos
    include icinga::scripts
    include icinga::service
    include icinga::serviceclasses
    include icinga::servicegroups
    include icinga::webapp

    if ($icinga::vars::devices) {
	create_resources(icinga::define::static, $icinga::vars::devices)
    }
}
