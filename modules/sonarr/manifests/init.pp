class sonarr {
    include sonarr::vars
    include mono

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
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
