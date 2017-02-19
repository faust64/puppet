class munin::rhel {
    common::define::package {
	"munin":
    }

    Package["munin"]
	-> File["Prepare Munin for further configuration"]
}
