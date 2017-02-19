class saslauthd::service {
    common::define::service {
	"saslauthd":
	    ensure => running;
    }
}
