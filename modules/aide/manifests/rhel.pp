class aide::rhel {
    common::define::package {
	"aide":
    }

    Package["aide"]
	-> File["Prepare aide for further configuration"]
}
