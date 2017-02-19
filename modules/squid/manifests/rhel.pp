class squid::rhel {
    common::define::package {
	"squid":
    }

    Package["squid"]
	-> File["Prepare Squid for further configuration"]
}
