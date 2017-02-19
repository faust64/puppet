class postgres::service {
    common::define::service {
	"postgresql":
	    ensure => running;
    }
}
