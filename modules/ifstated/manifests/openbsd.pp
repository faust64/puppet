class ifstated::openbsd {
    common::define::lined {
	"Enable Ifstated on boot":
	    line => "ifstated_flags=",
	    path => "/etc/rc.conf.local";
    }
}
