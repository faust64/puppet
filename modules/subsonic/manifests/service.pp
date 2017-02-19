class subsonic::service {
    common::define::service {
	"subsonic":
	    ensure  => running,
	    require => Class["java"];
    }
}
