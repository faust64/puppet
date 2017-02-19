class openvpn::openbsd {
    common::define::package {
	"openvpn":
    }

    Common::Define::Package["openvpn"]
	-> Group["OpenVPN runtime group"]
}
