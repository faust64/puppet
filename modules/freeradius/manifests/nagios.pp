class freeradius::nagios {
    nagios::define::probe {
	"freeradius":
	    description   => "$fqdn freeradius server",
	    servicegroups => "authentication",
	    use           => "critical-service";
    }
}
