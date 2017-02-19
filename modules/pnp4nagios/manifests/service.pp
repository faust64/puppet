class pnp4nagios::service {
    common::define::service {
	$pnp4nagios::vars::service_name:
	    ensure => running;
    }
}
