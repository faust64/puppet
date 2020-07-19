class sickbeard::nagios {
    if (! defined(Class["common::tools::netstat"])) {
	include common::tools::netstat
    }

    nagios::define::probe {
	"sickbeard":
	    description   => "$fqdn SickBeard service",
	    require       => Class["common::tools::netstat"],
	    servicegroups => "webservices",
	    use           => "jobs-service";
    }
}
