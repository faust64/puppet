class icecast {
    include icecast::vars
    include apache::utils

    case $operatingsystem {
	"CentOS", "RedHat": {
	    include icecast::rhel
	}
	"Debian", "Ubuntu": {
	    include icecast::debian
	}
	default: {
	    common::define::patchneeded { "icecast": }
	}
    }

    include icecast::config
    include icecast::service
}
