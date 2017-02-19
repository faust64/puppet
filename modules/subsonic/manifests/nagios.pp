class subsonic::nagios {
    nagios::define::probe {
	"subsonic":
	    description   => "$fqdn SubSonic service",
	    servicegroups => "webservices",
	    use           => "jobs-service";
    }
}
