class samba::debian {
    common::define::package {
	"samba":
    }

    Common::Define::Package["libpam-ldap"]
	-> Common::Define::Package["libnss-ldap"]
	-> Common::Define::Package["samba"]
	-> Common::Define::Service["samba"]
}
