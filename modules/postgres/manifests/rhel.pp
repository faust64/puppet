class postgres::rhel {
    common::define::package {
	"postgresql":
    }

    Package["postgresql"]
	-> File["Prepare postgresql main directory"]
}
