class muninnode::rhel {
    common::define::package {
	"munin-node":
    }

    Package["munin-node"]
	-> File["Install Munin custom plugins"]
	-> Common::Define::Lined["Ensure munin knows where to listen"]
}
