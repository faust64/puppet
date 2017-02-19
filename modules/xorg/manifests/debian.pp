class xorg::debian {
    common::define::package {
	[ "xorg", "ttf-mscorefonts-installer", "x11-xserver-utils" ]:
    }

    if ($xorg::vars::with_audio) {
	common::define::package {
	    [ "alsa-base", "alsa-utils" ]:
	}

	Package["alsa-base"]
	    -> Package["alsa-utils"]
	    -> File["Install asound configuration"]
    }

    Package["xorg"]
	-> Package["x11-xserver-utils"]
	-> Package["ttf-mscorefonts-installer"]
}
