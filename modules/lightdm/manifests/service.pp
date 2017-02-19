class lightdm::service {
    common::define::service {
	"lightdm":
	    ensure => running;
    }
}
