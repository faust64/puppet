class named::openbsd {
    common::define::lined {
	"Enable Named on boot":
	    line => "named_flags=",
	    path => "/etc/rc.conf.local";
    }
}
