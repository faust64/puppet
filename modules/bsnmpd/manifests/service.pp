class bsnmpd::service {
    common::define::service {
	"bsnmpd":
	    ensure => running;
    }
}
