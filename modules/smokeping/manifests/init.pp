class smokeping {
    include smokeping::vars

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include smokeping::debian
	}
	default: {
	    common::define::patchneeded { "smokeping": }
	}
    }

    include smokeping::config
    include smokeping::service
    include smokeping::webapp
}
