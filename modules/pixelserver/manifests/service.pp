class pixelserver::service {
    common::define::service {
	"pixelserver":
	    ensure => running;
    }
}
