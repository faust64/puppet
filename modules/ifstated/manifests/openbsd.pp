class ifstated::openbsd {
    file_line {
	"Enable Ifstated on boot":
	    line => "ifstated_flags=",
	    path => "/etc/rc.conf.local";
    }
}
