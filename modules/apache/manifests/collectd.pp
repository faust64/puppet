class apache::collectd {
    if ($apache::vars::with_collectd) {
	if (! defined(Class[collectd])) {
	    include collectd
	}
	if (! defined(Class[Apache::Status])) {
	    include apache::status
	}

	collectd::define::plugin {
	    "apache":
	}
    } else {
	collectd::define::plugin {
	    "apache":
		status => "absent";
	}
    }
}
