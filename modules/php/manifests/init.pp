class php {
    include php::vars
    include php::config

    case $operatingsystem {
	"CentOS", "RedHat": {
	    include php::rhel
	}
	"Debian", "Ubuntu": {
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
