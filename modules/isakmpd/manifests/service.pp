class isakmpd::service {
    common::define::service {
	"isakmpd":
	    ensure => running;
    }
}
