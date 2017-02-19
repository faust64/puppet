class rrdcached::service {
    common::define::service {
	"rrdcached":
	    ensure => running;
    }
}
