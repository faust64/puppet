class xinetd {
    include xinetd::vars

    case $operatingsystem {
	"CentOS", "RedHat": {
	    include xinetd::rhel
	}
	"Debian", "Ubuntu": {
	    include xinetd::debian
	}
	default: {
	    common::define::patchneeded { "xinetd": }
	}
    }

    include xinetd::config
    include xinetd::service
}
