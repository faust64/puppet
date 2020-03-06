class openvpn::openbsd {
    common::define::package {
	"x11vnc":
    }

    Common::Define::Package["x11vnc"]
	-> File["Install x11-VNC wrapper script"]
	-> Common::Define::Service["x11vnc"]
}
