class firewalld::rhel {
    common::define::package {
	"firewalld":
    }

    Common::Define::Package["firewalld"]
	-> Common::Define::Service["firewalld"]
}
