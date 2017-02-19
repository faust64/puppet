class moin {
    include moin::vars

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include moin::debian
	}
	default: {
	    common::define::patchneeded { "moin": }
	}
    }

    include moin::config
    include moin::scripts
    include moin::service
    include moin::webapp
}
