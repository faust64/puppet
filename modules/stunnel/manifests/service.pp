class stunnel::service {
    common::define::service {
	$stunnel::vars::srvname:
	    ensure => running;
    }
}
