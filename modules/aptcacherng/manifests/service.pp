class aptcacherng::service {
    common::define::service {
	"apt-cacher-ng":
	    ensure => running;
    }
}
