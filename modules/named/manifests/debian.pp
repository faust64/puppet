class named::debian {
    common::define::package {
	"bind9":
    }

    Package["bind9"]
	-> File["Prepare named for further configuration"]
	-> File["Prepare named log directory"]
}
