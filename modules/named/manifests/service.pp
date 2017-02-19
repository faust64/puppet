class named::service {
    common::define::service {
	$named::vars::service_name:
	    ensure => running;
    }
}
