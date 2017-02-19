class puppet::service {
    common::define::service {
	$puppet::vars::puppet_srvname:
	    ensure => running;
    }
}
