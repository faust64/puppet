class nagios::service {
    common::define::service {
	$nagios::vars::nrpe_service_name:
	    ensure => running;
    }
}
