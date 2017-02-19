class rsyslog::service {
    common::define::service {
	$rsyslog::vars::service_name:
	    ensure => running;
    }
}
