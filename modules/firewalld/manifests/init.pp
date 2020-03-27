class firewalld {
    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include firewalld::rhel
	}
	default: {
	    common::define::patchneeded { "apache": }
	}
    }

    include firewalld::service
}
