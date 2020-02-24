class xorg::rhel {
    common::define::package {
	[ "msttcore-fonts", "xorg-x11-server-Xorg", "xorg-x11-server-utils" ]:
    }

    if ($xorg::vars::with_audio) {
	yum::define::repo {
	    "ATrpms":
		baseurl    => "https://dl.atrpms.net/el$\$releasever-\$basearch/atrpms/stable",
		descr      => "RHEL ATrpms - media-related utilities",
		gpgkey     => "http://ATrpms.net/RPM-GPG-KEY.atrpms";
	}

	common::define::package {
	    [ "alsa-driver", "alsa-lib" ]:
		require => Yum::Define::Repo["ATrpms"];
	}

	Package["alsa-driver"]
	    -> Package["alsa-lib"]
	    -> File["Install asound configuration"]
    }

    Package["xorg-x11-server-Xorg"]
	-> Package["msttcore-fonts"]
	-> Package["xorg-x11-server-utils"]
}
