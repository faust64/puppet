class lightdm::freebsd {
    common::define::package {
	"lightdm":
    }

    Package["lightdm"]
	-> File["Prepare Lightdm for further configuration"]
}
