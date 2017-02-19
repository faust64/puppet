class nfs::service {
    common::define::service {
	$nfs::vars::srvname:
	    ensure => running;
    }
}
