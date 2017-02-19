class isakmpd::freebsd {
    common::define::package {
	"isakmpd":
    }

    file_line {
	"Enable Isakmpd on boot":
	    line => "isakmpd_enable=",
	    path => "/etc/rc.conf";
    }
}
