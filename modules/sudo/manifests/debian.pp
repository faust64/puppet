class sudo::debian {
    common::define::package {
	"sudo":
	    ensure => latest;
    }
}
