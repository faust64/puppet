class openvpn::rhel {
    common::define::package {
	"openvpn":
    }

    if ($openvpn::vars::openvpn_auth_source == "ldap") {
	common::define::package {
	    "openvpn-auth-ldap":
	}

	Package["openvpn-auth-ldap"]
	    -> Package["openvpn"]
    }

    Common::Define::Package["openvpn"]
	-> Group["OpenVPN runtime group"]
}
