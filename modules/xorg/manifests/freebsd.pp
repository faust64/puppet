class xorg::freebsd {
    common::define::package {
	[ "xorg-server", "xorg-fonts-truetype" ]:
    }

    if ($xorg::vars::with_audio) {
	common::define::package {
	    [ "alsa-lib", "alsa-plugins" ]:
	}

	Package["alsa-lib"]
	    -> Package["alsa-plugins"]
	    -> File["Install asound configuration"]
    }

    Package["xorg-server"]
	-> Package["xorg-fonts-truetype"]
}
