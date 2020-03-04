class rsyslog::nagios {
    if (! defined(Class[Common::Tools::Netstat])) {
	include common::tools::netstat
    }

    nagios::define::probe {
	"rsyslog":
	    description   => "$fqdn rsyslog",
	    require       => Class[Common::Tools::Netstat],
	    servicegroups => "system",
	    use           => "error-service";
    }
}
