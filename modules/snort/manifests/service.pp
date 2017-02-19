class snort::service {
    common::define::service {
	"snort":
	    ensure => running;
    }
}
