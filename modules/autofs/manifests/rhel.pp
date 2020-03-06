class autofs::rhel {
    common::define::package {
	"autofs":
    }

    Common::Define::Package["autofs"]
	-> Common::Define::Service["autofs"]
}
