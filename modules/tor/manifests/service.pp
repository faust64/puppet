class tor::service {
    common::define::service {
	"tor":
	    ensure => running;
    }
}
