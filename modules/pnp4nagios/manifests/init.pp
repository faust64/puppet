class pnp4nagios {
    include pnp4nagios::vars

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include pnp4nagios::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include pnp4nagios::debian
	}
	default: {
	    common::define::patchneeded { "pnp4nagios": }
	}
    }

    include pnp4nagios::config
    include pnp4nagios::service
}
