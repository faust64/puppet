class elasticsearch::service {
    common::define::service {
	"elasticsearch":
	    ensure => running;
    }
}
