class wpasupplicant::rhel {
    common::define::package {
	"wpa_supplicant":
    }

    Package["wpa_supplicant"]
	-> File["Prepare WPA Supplicant for further configuration"]
}
