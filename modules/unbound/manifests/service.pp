class unbound::service {
    common::define::service {
	"unbound":
	    ensure => running;
    }
}
