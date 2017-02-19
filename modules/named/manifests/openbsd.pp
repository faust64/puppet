class named::openbsd {
    file_line {
	"Enable Named on boot":
	    line => "named_flags=",
	    path => "/etc/rc.conf.local";
    }
}
