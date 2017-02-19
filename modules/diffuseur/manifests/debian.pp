class diffuseur::debian {
    common::define::package {
	[ "python-dbus", "xterm" ]:
    }

    if ($lsbdistcodename == "wheezy") {
	common::define::package {
	    "gstreamer0.10-alsa":
	}
    }
    else {
	common::define::patchneeded { "diffuseur-deb-release": }
    }
}
