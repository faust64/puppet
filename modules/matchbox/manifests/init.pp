class matchbox {
    include xorg
    include matchbox::vars

    if ($matchbox::vars::app_url) {
	if ($matchbox::vars::preferred_browser == "chromium") {
	    include sqlite
	    include chromium
	} elsif ($matchbox::vars::preferred_browser == "midori") {
	    include midori
	}
    } elsif ($matchbox::vars::feed_url) {
	include vlc
    }

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include matchbox::debian
	}
	default: {
	    common::define::patchneeded { "matchbox": }
	}
    }

    include matchbox::cleanup
    include matchbox::config
}
