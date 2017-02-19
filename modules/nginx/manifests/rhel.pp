class nginx::rhel {
    common::define::package {
	"nginx":
    }

    Common::Define::Package["nginx"]
	-> File["Drop nginx default enabled configuration"]
	-> Common::Define::Service["nginx"]
}
