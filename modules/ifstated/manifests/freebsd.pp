class ifstated::freebsd {
    common::define::package {
	"ifstated":
    }

    common::define::lined {
	"Enable Ifstated on boot":
	    line => "ifstated_enable=",
	    path => "/etc/rc.conf";
    }
}
