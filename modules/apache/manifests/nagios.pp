class apache::nagios {
    nagios::define::probe {
	"apache":
	    description   => "$fqdn apache",
	    pluginconf    => "webserver",
	    servicegroups => "webservices",
	    use           => "critical-service";
    }

    if ($apache::vars::listen_ports['ssl'] != false) {
	nagios::define::check_certificates {
	    "apache":
	}
    }
}
