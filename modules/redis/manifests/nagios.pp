class redis::nagios {
    include common::libs::perlnagiosplugin
    include common::libs::perlredis

    nagios::define::probe {
	"redis":
	    description   => "$fqdn redis",
	    pluginargs    =>
		[
		    '--host', $redis::vars::listen_address,
		    '--port', $redis::vars::listen_port
		],
	    servicegroups => "databases",
	    use           => "critical-service";
    }

    if ($redis::vars::slaveof) {
	nagios::define::probe {
	    "sentinel":
		description   => "$fqdn sentinel",
		pluginargs    =>
		    [
			'--host', $redis::vars::listen_address,
			'--port', $redis::vars::sentinel_port
		    ],
		servicegroups => "databases",
		use           => "critical-service";
	}
    }
}
