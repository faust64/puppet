class thruk::service {
    common::define::service {
	"thruk":
	    ensure  => running,
	    require => Service[$thruk::vars::apache_srvname];
    }
}
