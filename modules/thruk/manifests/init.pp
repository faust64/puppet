class thruk {
    include thruk::vars

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include thruk::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include thruk::debian
	}
	default: {
	    common::define::patchneeded { "thruk": }
	}
    }

    include thruk::config
    include thruk::logrotate
    include thruk::service
    include thruk::webapp
}
