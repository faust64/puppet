class isakmpd::freebsd {
    common::define::package {
	"isakmpd":
    }

    common::define::lined {
	"Enable Isakmpd on boot":
	    line => "isakmpd_enable=",
	    path => "/etc/rc.conf";
    }
}
