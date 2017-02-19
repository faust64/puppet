class collectd::rhel {
    common::define::package {
	"collectd":
    }

    Package["collectd"]
	-> File["Prepare collectd for further configuration"]
	-> Service["collectd"]
}
