class named::collectd {
    if ($named::vars::with_collectd) {
	if (! defined(Class[collectd])) {
	    include collectd
	}
	if (! defined(Class[Apache::Status])) {
	    include named::status
	}

	collectd::define::plugin {
	    "named":
		source => "dns";
	}
    } else {
	collectd::define::plugin {
	    "named":
		status => "absent";
	}
    }
}
