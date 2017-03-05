class smokeping {
    include smokeping::vars

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
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
