class jenkins::service {
    common::define::service {
	"jenkins":
	    ensure => running;
    }
}
