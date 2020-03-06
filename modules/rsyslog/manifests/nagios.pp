class rsyslog::nagios {
    if (! defined(Class["common::tools::netstat"])) {
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
