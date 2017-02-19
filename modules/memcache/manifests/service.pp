class memcache::service {
    common::define::service {
	$memcache::vars::service_name:
	    ensure => running;
    }
}
