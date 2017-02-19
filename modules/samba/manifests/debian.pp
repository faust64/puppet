class samba::debian {
    common::define::package {
	"samba":
    }

    Package["libpam-ldap"]
	-> Package["libnss-ldap"]
	-> Package["samba"]
	-> Service["samba"]
}
