class stanchion {
    include stanchion::vars

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
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
