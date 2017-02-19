class munin::debian {
    common::define::package {
	"munin":
    }

    Package["munin"]
	-> Class["rrdcached"]
	-> File["Prepare Munin for further configuration"]
}
