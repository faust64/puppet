class collectd::rhel {
    common::define::package {
	"collectd":
    }

    Common::Define::Package["collectd"]
	-> File["Prepare collectd for further configuration"]
	-> Common::Define::Service["collectd"]
}
