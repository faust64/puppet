class certbot {
    include certbot::vars

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include certbot::debian
	}
	default: {
	    common::define::patchneeded { "certbot": }
	}
    }

    include certbot::config
    include certbot::jobs
}
