class muninnode {
    include muninnode::vars

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include muninnode::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include muninnode::debian
	}
	"FreeBSD": {
	    include muninnode::freebsd
	}
	"OpenBSD": {
	    include muninnode::openbsd
	}
	default: {
	    common::define::patchneeded { "munin-node": }
	}
    }

    include muninnode::plugins
    include muninnode::config
    include muninnode::service
    include muninnode::probes
    include muninnode::register

    if ($kernel == "Linux") {
	include muninnode::logrotate
    }
}
