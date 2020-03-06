class dhcpd::openbsd {
    common::define::lined {
	"Enable Dhcpd on boot":
	    line => "dhcpd_flags=",
	    path => "/etc/rc.conf.local";
    }
}
