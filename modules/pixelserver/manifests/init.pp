class pixelserver {
    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include pixelserver::debian
	}
	default: {
	    common::define::patchneeded { "pixelserver": }
	}
    }

    include pixelserver::scripts
    include pixelserver::service
    include pixelserver::webapp
}
