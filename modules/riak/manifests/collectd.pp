class riak::collectd {
    if ($riak::vars::with_collectd) {
	if (! defined(Class["collectd"])) {
	    include collectd
	}

	collectd::define::plugin {
	    "riak":
	}
    } else {
	collectd::define::plugin {
	    "riak":
		status => "absent";
	}
    }
}
