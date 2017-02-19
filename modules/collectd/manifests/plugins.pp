class collectd::plugins {
    collectd::define::plugin {
	[ "log", "network", "rrd" ]:
    }

    if ($collectd::vars::plugins != false) {
	collectd::define::plugin {
	    "defaults":
		source => "default";
	}
    }

    if ($collectd::vars::graphite != false) {
	collectd::define::plugin {
	    "graphite":
	}
    }
}
