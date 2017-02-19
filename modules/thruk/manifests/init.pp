class thruk {
    include thruk::vars

    case $operatingsystem {
	"CentOS", "RedHat": {
	    include thruk::rhel
	}
	"Debian", "Ubuntu": {
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
