class certbot {
    include certbot::vars

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include certbot::debian
	}
	default: {
	    common::define::patchneeded { "certbot": }
	}
    }

    include certbot::config
    include certbot::jobs
}
