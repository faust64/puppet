class pnp4nagios::rhel {
    common::define::package {
	"pnp4nagios":
    }

    Package["pnp4nagios"]
	-> File["Prepare pnp4nagios for further configuration"]
}
