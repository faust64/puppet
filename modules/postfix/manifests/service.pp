class postfix::service {
    common::define::service {
	"postfix":
	    ensure => running;
    }
}
