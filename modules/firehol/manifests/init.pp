class firehol {
    include firehol::vars

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include firehol::debian
	}
	default: {
	    common::define::patchneeded { "firehol": }
	}
    }

    include firehol::config
    include firehol::service
}
