class pnp4nagios {
    include pnp4nagios::vars

    case $operatingsystem {
	"CentOS", "RedHat": {
	    include pnp4nagios::rhel
	}
	"Debian", "Ubuntu": {
	    include pnp4nagios::debian
	}
	default: {
	    common::define::patchneeded { "pnp4nagios": }
	}
    }

    include pnp4nagios::config
    include pnp4nagios::service
}
