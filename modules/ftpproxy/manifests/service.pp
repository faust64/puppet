class ftpproxy::service {
    common::define::service {
	"ftpproxy":
	    ensure => running;
    }
}
