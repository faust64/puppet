class airsonic::nagios {
    if (! defined(Class[Common::Tools::Netstat])) {
	include common::tools::netstat
    }

    nagios::define::probe {
	"airsonic":
	    description   => "$fqdn AirSonic service",
	    require       => Class[Common::Tools::Netstat],
	    servicegroups => "webservices",
	    use           => "jobs-service";
    }
}
