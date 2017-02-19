class wpasupplicant::debian {
    common::define::package {
	"wpasupplicant":
    }

    Package["wpasupplicant"]
	-> File["Prepare WPA Supplicant for further configuration"]
}
