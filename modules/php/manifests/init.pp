class php {
    include php::vars
    include php::config

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include php::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include php::debian
	}
	"FreeBSD": {
	    include php::freebsd
	}
	default: {
	    common::define::patchneeded { "php": }
	}
    }

    include php::modules
    include php::munin
    include php::service
}
