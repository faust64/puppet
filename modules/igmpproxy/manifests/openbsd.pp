class igmpproxy::openbsd {
    common::define::package {
	"igmpproxy":
    }

    Package["igmpproxy"]
	-> File["Install IGMP proxy main configuration"]
}
