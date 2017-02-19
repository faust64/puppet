class ssh::service {
    common::define::service {
	$ssh::vars::ssh_service_name:
	    ensure => running;
    }
}
