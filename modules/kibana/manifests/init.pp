class kibana {
    include kibana::vars

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include kibana::debian
	}
	default: {
	    common::define::patchneeded { "kibana": }
	}
    }

    include kibana::config
    include kibana::service
    include kibana::webapp
}
