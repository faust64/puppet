class sickbeard::nagios {
    nagios::define::probe {
	"sickbeard":
	    description   => "$fqdn SickBeard service",
	    servicegroups => "webservices",
	    use           => "jobs-service";
    }
}
