class sonarr {
    include sonarr::vars
    include mono

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include sonarr::debian
	}
	default: {
	    common::define::patchneeded { "sonarr": }
	}
    }

    include sonarr::config
    include sonarr::service
    include sonarr::webapp
}
