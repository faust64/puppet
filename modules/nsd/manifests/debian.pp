class nsd::debian {
    common::define::package {
	"nsd":
    }

    Common::Define::Package["nsd"]
	-> File["Prepare NSD for further configuration"]
	-> Common::Define::Service["nsd"]
}
