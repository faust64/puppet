class collectd::service {
    common::define::service {
	"collectd":
	    ensure => running;
    }
}
