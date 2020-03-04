class aptcacherng::nagios {
    if (! defined(Class[Common::Tools::Netstat])) {
	include common::tools::netstat
    }

    nagios::define::probe {
	"aptcacher":
	    description   => "$fqdn aptcacher server",
	    require       => Class[Common::Tools::Netstat],
	    servicegroups => "netservices",
	    use           => "critical-service";
    }
}
