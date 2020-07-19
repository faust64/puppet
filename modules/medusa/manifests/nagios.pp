class medusa::nagios {
    if (! defined(Class["common::tools::netstat"])) {
	include common::tools::netstat
    }

    nagios::define::probe {
	"medusa":
	    description   => "$fqdn Medusa service",
	    require       => Class["common::tools::netstat"],
	    servicegroups => "webservices",
	    use           => "jobs-service";
    }
}
