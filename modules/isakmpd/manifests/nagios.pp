class isakmpd::nagios {
    nagios::define::probe {
	"isakmpd":
	    description   => "$fqdn isakmpd service",
	    servicegroups => "network",
	    use           => "critical-service";
    }
}
