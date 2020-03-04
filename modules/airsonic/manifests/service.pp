class airsonic::service {
    common::define::service {
	"airsonic":
	    ensure  => running,
	    require => Class["java"];
    }
}
