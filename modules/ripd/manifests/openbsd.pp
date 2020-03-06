class ripd::openbsd {
    common::define::lined {
	"Enable ripd on boot":
	    line  => "ripd_flags=",
#	    match => "ripd_flags=",
	    path  => "/etc/rc.conf.local";
    }
}
