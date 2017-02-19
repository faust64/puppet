class x11vnc::service {
    common::define::service {
	"x11vnc":
	    ensure  => running,
	    require =>
		[
		    File["Install x11-VNC init script"],
		    File["Install x11-VNC wrapper configuration"],
		    File["Install x11-VNC wrapper script"]
		];
    }
}
