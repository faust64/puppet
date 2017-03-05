class pixelserver {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
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
