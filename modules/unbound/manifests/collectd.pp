class unbound::collectd {
    if ($unbound::vars::with_collectd) {
	if (! defined(Class[collectd])) {
	    include collectd
	}
	if (! defined(Class[Apache::Status])) {
	    include unbound::status
	}

	collectd::define::plugin {
	    "unbound":
		source => "dns";
	}
    } else {
	collectd::define::plugin {
	    "unbound":
		status => "absent";
	}
    }
}
