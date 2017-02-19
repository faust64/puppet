class stanchion {
    include stanchion::vars

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include stanchion::debian
	}
	default: {
	    common::define::patchneeded { "stanchion": }
	}
    }

    include stanchion::config
    include stanchion::nagios
    include stanchion::service
}
