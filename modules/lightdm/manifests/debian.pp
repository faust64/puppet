class lightdm::debian {
    common::define::package {
	"lightdm":
    }

    Package["lightdm"]
	-> File["Prepare Lightdm for further configuration"]
}
