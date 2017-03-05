class iscsiinitiator {
    include iscsiinitiator::vars

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
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
