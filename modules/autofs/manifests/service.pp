class autofs::service {
    common::define::service {
	"autofs":
	    ensure => running;
    }
}
