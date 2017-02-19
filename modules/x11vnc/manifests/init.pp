class x11vnc($service_depends = false,
	     $service_runs_as = "root") {
    include x11vnc::vars

    case $operatingsystem {
	"FreeBSD": {
	    include x11vnc::freebsd
	}
	"OpenBSD": {
	    include x11vnc::openbsd
	}
	default: {
	    common::define::patchneeded { "x11vnc": }
	}
    }

    include x11vnc::config
    include x11vnc::scripts
    include x11vnc::service
    include x11vnc::nagios
}
