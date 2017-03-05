class media {
    include nginx
    include common::libs::exif
    include media::vars

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include media::debian
	}
	default: {
	    common::define::patchneeded { "media": }
	}
    }

#   include media::default
    include media::scripts
    include media::service
    include media::webapp
}
