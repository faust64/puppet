class kibana {
    include kibana::vars

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
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
