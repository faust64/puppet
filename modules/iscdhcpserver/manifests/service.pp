class iscdhcpserver::service {
    common::define::service {
	$iscdhcpserver::vars::service_name:
	    ensure => running;
    }
}
