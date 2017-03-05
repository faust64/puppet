class clamav {
    include clamav::vars

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include clamav::debian
	}
	default: {
	    common::define::patchneeded { "clamav": }
	}
    }

    include clamav::config
    include clamav::scripts
    include clamav::jobs
}
