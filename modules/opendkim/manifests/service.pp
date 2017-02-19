class opendkim::service {
    common::define::service {
	"opendkim":
	    ensure => running;
    }
}
