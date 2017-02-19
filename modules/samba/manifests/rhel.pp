class samba::rhel {
    common::define::package {
	"samba":
    }

    Package["nss-pam-ldapd"]
	-> Package["samba"]
	-> Service["samba"]
}
