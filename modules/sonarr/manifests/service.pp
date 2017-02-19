class sonarr::service {
    common::define::service {
	"sonarr":
	    ensure  => running,
	    require => Exec["Reload systemd configuration"];
    }
}
