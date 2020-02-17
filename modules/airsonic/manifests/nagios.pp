class airsonic::nagios {
    nagios::define::probe {
	"airsonic":
	    description   => "$fqdn AirSonic service",
	    servicegroups => "webservices",
	    use           => "jobs-service";
    }
}
