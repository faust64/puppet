class bgpd::openbsd {
    common::define::lined {
	"Enable bgpd on boot":
	    line  => "bgpd_flags=",
#	    match => 'bgpd_flags=',
	    path  => "/etc/rc.conf.local";
    }
}
