class bgpd::openbsd {
    file_line {
	"Enable bgpd on boot":
	    line  => "bgpd_flags=",
#	    match => 'bgpd_flags=',
	    path  => "/etc/rc.conf.local";
    }
}
