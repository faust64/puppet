class flumotion::debian {
    common::define::package {
	"flumotion":
    }

    Package["flumotion"]
	-> File["Prepare flumotion for further configuration"]
}
