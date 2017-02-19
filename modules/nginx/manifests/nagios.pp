class nginx::nagios {
    nagios::define::probe {
	"nginx":
	    description   => "$fqdn nginx",
	    pluginconf    => "webserver",
	    servicegroups => "webservices",
	    use           => "critical-service";
    }

    if ($nginx::vars::listen_ports['ssl'] != false) {
	nagios::define::check_certificates {
	    "nginx":
	}
    }
}
