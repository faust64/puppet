class rsyslog::nagios {
    nagios::define::probe {
	"rsyslog":
	    description   => "$fqdn rsyslog",
	    servicegroups => "system",
	    use           => "error-service";
    }
}
