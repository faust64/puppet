class mongodb::service {
    common::define::service {
	"mongodb":
	    ensure => running;
    }
}
