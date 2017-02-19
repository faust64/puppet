class squid::nagios {
    nagios::define::probe {
	"squid":
	    description   => "$fqdn squid",
	    servicegroups => "webservices",
	    use           => "critical-service";
    }
}
