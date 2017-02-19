class haproxy::service {
    common::define::service {
	$haproxy::vars::service_name:
	    ensure => "running";
    }
}
