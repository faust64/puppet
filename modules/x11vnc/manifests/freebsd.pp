class x11vnc::freebsd {
    common::define::package {
	"x11vnc":
    }

    file {
	"Enable x11-VNC service":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$srvname],
	    owner   => root,
	    path    => "/etc/rc.conf.d/x11vnc",
	    require =>
		[
		    Package["x11vnc"],
		    File["Prepare FreeBSD services configuration directory"]
		],
	    source  => "puppet:///modules/x11vnc/freebsd.rc";
    }

    Common::Define::Package["x11vnc"]
	-> File["Enable x11-VNC service"]
	-> File["Install x11-VNC wrapper script"]
	-> Common::Define::Service["x11vnc"]
}
