class ossec::service {
    common::define::service {
	$ossec::vars::service_name:
	    ensure => running;
    }
}
