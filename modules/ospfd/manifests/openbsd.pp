class ospfd::openbsd {
    file_line {
	"Enable ospfd on boot":
	    line  => "ospfd_flags=",
#	    match => 'ospfd_flags=',
	    path  => "/etc/rc.conf.local";
    }
}
