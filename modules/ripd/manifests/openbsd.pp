class ripd::openbsd {
    file_line {
	"Enable ripd on boot":
	    line  => "ripd_flags=",
#	    match => "ripd_flags=",
	    path  => "/etc/rc.conf.local";
    }
}
