class transmission::service {
    common::define::service {
	$transmission::vars::srvname:
	    ensure => "running";
    }
}
