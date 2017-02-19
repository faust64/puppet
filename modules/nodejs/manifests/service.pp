class nodejs::service {
    common::define::service {
	$nodejs::vars::service_name:
	    ensure => running;
    }
}
