class openbox::freebsd {
    common::define::package {
	"openbox":
    }

    if ($openbox::with_fbi) {
	common::define::package {
	    "fbi":
	}

	Package["fbi"]
	    -> File["Install openbox user autostart"]
    }
    if ($openbox::with_feh) {
	common::define::package {
	    "feh":
	}

	Package["feh"]
	    -> File["Install openbox user autostart"]
    }
    if ($openbox::with_unclutter) {
	common::define::package {
	    "unclutter":
	}

	Package["unclutter"]
	    -> File["Install openbox user autostart"]
    }
}
