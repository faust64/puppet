class haproxy::collectd {
    $runtime_user = $haproxy::vars::nagios_runtime_user
    $stats_socket = $haproxy::vars::stats_socket

    if ($haproxy::vars::with_collectd) {
	if (! defined(Class[collectd])) {
	    include collectd
	}

	file {
	    "Install HAproxy collectd sudoers":
		content => template("haproxy/sudoers-collectd.erb"),
		group   => hiera("gid_zero"),
		mode    => "0440",
		owner   => root,
		path    => "/etc/sudoers.d/collectd-haproxy";
	}

	collectd::define::plugin {
	    "haproxy":
		require =>
		    [
			File["Install HAproxy collectd collection script"],
			File["Install HAproxy collectd sudoers"]
		    ];
	}
    } else {
	collectd::define::plugin {
	    "haproxy":
		status => "absent";
	}
    }
}
