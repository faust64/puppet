class logrotate {
    include logrotate::vars

    case $operatingsystem {
	"CentOS", "RedHat": {
	    include logrotate::rhel
	}
	"Debian", "Ubuntu": {
	    include logrotate::debian
	}
	default: {
	    common::define::patchneeded { "logrotate": }
	}
    }

    include logrotate::config
}
