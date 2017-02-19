class dhcrelay::service {
    common::define::service {
	"dhcrelay":
	    ensure => running;
    }
}
