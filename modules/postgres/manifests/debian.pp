class postgres::debian {
    common::define::package {
	"postgresql":
    }

    Package["postgresql"]
	-> File["Prepare postgresql main directory"]
}
