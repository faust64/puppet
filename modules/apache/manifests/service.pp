class apache::service {
    common::define::service {
	$apache::vars::service_name:
	    ensure => running;
    }
}
