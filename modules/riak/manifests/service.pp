class riak::service {
    common::define::service {
	"riak":
	    ensure => running;
    }
}
