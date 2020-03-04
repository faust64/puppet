class subsonic::nagios {
    if (! defined(Class[Common::Tools::Netstat])) {
	include common::tools::netstat
    }

    nagios::define::probe {
	"subsonic":
	    description   => "$fqdn SubSonic service",
	    require       => Class[Common::Tools::Netstat],
	    servicegroups => "webservices",
	    use           => "jobs-service";
    }
}
