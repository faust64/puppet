class logrotate {
    include logrotate::vars

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include logrotate::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include logrotate::debian
	}
	default: {
	    common::define::patchneeded { "logrotate": }
	}
    }

    include logrotate::config
}
