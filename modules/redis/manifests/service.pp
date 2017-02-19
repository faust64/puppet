class redis::service {
    common::define::service {
	$redis::vars::service_name:
	    ensure => running;
    }

    if ($redis::vars::slaveof) {
	common::define::service {
	    "redis-sentinel":
		ensure => running;
	}

	Common::Define::Service[$redis::vars::service_name]
	    -> Common::Define::Service["redis-sentinel"]
    }
}
