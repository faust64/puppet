class dhcpd::service {
    common::define::service {
	"dhcpd":
	    ensure => running;
    }
}
