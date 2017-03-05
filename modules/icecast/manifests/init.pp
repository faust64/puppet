class icecast {
    include icecast::vars
    include apache::utils

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include icecast::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include icecast::debian
	}
	default: {
	    common::define::patchneeded { "icecast": }
	}
    }

    include icecast::config
    include icecast::service
}
