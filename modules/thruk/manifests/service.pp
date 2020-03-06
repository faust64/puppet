class thruk::service {
    common::define::service {
	"thruk":
	    ensure  => running,
	    require => Common::Define::Service[$thruk::vars::apache_srvname];
    }
}
