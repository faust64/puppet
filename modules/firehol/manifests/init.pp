class firehol {
    include firehol::vars

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include firehol::debian
	}
	default: {
	    common::define::patchneeded { "firehol": }
	}
    }

    include firehol::config
    include firehol::service
}
