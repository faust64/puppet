class mysql::service {
    common::define::service {
	$mysql::vars::service_name:
	    ensure => running;
    }
}
