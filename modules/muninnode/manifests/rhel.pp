class muninnode::rhel {
    common::define::package {
	"munin-node":
    }

    Package["munin-node"]
	-> File["Install Munin custom plugins"]
	-> File_line["Ensure munin knows where to listen"]
}
