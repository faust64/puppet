class dhcpd::openbsd {
    file_line {
	"Enable Dhcpd on boot":
	    line => "dhcpd_flags=",
	    path => "/etc/rc.conf.local";
    }
}
