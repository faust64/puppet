class relayd::service {
    common::define::service {
	"relayd":
	    ensure => running;
    }
}
