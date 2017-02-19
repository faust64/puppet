class autofs::rhel {
    common::define::package {
	"autofs":
    }

    Package["autofs"]
	-> Service["autofs"]
}
