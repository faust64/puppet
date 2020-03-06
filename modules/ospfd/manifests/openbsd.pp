class ospfd::openbsd {
    common::define::lined {
	"Enable ospfd on boot":
	    line  => "ospfd_flags=",
#	    match => 'ospfd_flags=',
	    path  => "/etc/rc.conf.local";
    }
}
