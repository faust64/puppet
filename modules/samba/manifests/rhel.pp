class samba::rhel {
    common::define::package {
	"samba":
    }

    Common::Define::Package["nss-pam-ldapd"]
	-> Common::Define::Package["samba"]
	-> Common::Define::Service["samba"]
}
