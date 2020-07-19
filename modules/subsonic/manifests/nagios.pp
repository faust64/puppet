class subsonic::nagios {
    if (! defined(Class["common::tools::netstat"])) {
	include common::tools::netstat
    }

    nagios::define::probe {
	"subsonic":
	    description   => "$fqdn SubSonic service",
	    require       => Class["common::tools::netstat"],
	    servicegroups => "webservices",
	    use           => "jobs-service";
    }
}
