class pixelserver {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include pixelserver::debian
	}
	"OpenBSD": {
	    include pixelserver::openbsd
	}
	default: {
	    common::define::patchneeded { "pixelserver": }
	}
    }

    include pixelserver::scripts
    include pixelserver::service
    include pixelserver::webapp
}
