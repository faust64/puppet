class muninnode::rhel {
    common::define::package {
	"munin-node":
    }

    firewalld::define::addrule {
	"munin":
	    port => $muninnode::vars::munin_port;
    }

    Package["munin-node"]
	-> File["Install Munin custom plugins"]
	-> Common::Define::Lined["Ensure munin knows where to listen"]
}
