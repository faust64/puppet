class airsonic::nagios {
    if (! defined(Class["common::tools::netstat"])) {
	include common::tools::netstat
    }

    nagios::define::probe {
	"airsonic":
	    description   => "$fqdn AirSonic service",
	    require       => Class["common::tools::netstat"],
	    servicegroups => "webservices",
	    use           => "jobs-service";
    }
}
