class diffuseur {
    class {
	openbox:
	    with_feh => true;
    }

    include flumotion
    include vlc

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include diffuseur::debian
	}
	default: {
	    common::define::patchneeded { "diffuseur": }
	}
    }

    include diffuseur::config
}
