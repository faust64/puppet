class freeradius::debian {
    common::define::package {
	[ "freeradius", "freeradius-ldap", "freeradius-utils" ]:
    }

    Common::Define::Package["freeradius"]
	-> File["Prepare Freeradius for further configuration"]
}
