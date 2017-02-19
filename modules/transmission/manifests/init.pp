class transmission {
    include transmission::vars

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include transmission::debian
	}
	default: {
	    common::define::patchneeded { "transmission": }
	}
    }

    include transmission::config
    include transmission::configd
    include transmission::munin
    include transmission::nagios
    include transmission::profile
    include transmission::scripts
    include transmission::service
    include transmission::webapp
}
