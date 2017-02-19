class postgres::openbsd {
    common::define::package {
	[ "postgresql-client", "postgresql-server" ]:
    }

    Package["postgresql-client"]
	-> Package["postgresql-server"]
	-> File["Prepare postgresql main directory"]
}
