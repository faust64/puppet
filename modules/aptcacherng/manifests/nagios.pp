class aptcacherng::nagios {
    nagios::define::probe {
	"aptcacher":
	    description   => "$fqdn aptcacher server",
	    servicegroups => "netservices",
	    use           => "critical-service";
    }
}
