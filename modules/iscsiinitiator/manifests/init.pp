class iscsiinitiator {
    include iscsiinitiator::vars

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include iscsiinitiator::debian
	}
	"CentOS", "RedHat": {
	    include iscsiinitiator::rhel
	}
	default: {
	    common::define::patchneeded { "iscsiinitiator": }
	}
    }

    include iscsiinitiator::config
}
