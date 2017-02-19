class ifstated::freebsd {
    common::define::package {
	"ifstated":
    }

    file_line {
	"Enable Ifstated on boot":
	    line => "ifstated_enable=",
	    path => "/etc/rc.conf";
    }
}
