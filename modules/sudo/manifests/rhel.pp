class sudo::rhel {
    common::define::package {
	"sudo":
	    ensure => latest;
    }
}
