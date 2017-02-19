class xinetd::debian {
    common::define::package {
	"xinetd":
    }

    Common::Define::Package["xinetd"]
	-> File["Install Xinetd main configuration"]
	-> Common::Define::Service["xinetd"]
}
