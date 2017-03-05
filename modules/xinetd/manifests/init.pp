class xinetd {
    include xinetd::vars

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include xinetd::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include xinetd::debian
	}
	default: {
	    common::define::patchneeded { "xinetd": }
	}
    }

    include xinetd::config
    include xinetd::service
}
