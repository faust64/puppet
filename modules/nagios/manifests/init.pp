class nagios {
    include nagios::vars

    case $operatingsystem {
	"CentOS", "RedHat": {
	    include nagios::rhel
	}
	"Debian", "Ubuntu": {
	    include nagios::debian
	}
	"FreeBSD": {
	    include nagios::freebsd
	}
	"OpenBSD": {
	    include nagios::openbsd
	}
	default: {
	    common::define::patchneeded { "nagios": }
	}
    }

    include nagios::config
    include nagios::filetraq
    include nagios::plugins
    include nagios::probe
    include nagios::service
}
