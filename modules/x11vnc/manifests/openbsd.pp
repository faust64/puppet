class openvpn::openbsd {
    common::define::package {
	"x11vnc":
    }

    Package["x11vnc"]
	-> File["Install x11-VNC wrapper script"]
	-> Service["x11vnc"]
}
