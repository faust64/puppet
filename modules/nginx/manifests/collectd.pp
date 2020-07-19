class nginx::collectd {
    if ($nginx::vars::with_collectd) {
	if (! defined(Class["collectd"])) {
	    include collectd
	}
	if (! defined(Class["nginx::status"])) {
	    include nginx::status
	}

	collectd::define::plugin {
	    "nginx":
	}
    } else {
	collectd::define::plugin {
	    "nginx":
		status => "absent";
	}
    }
}
