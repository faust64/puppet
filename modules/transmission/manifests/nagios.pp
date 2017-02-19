class transmission::nagios {
    nagios::define::probe {
	"transmission":
	    description   => "$fqdn transmission daemon",
	    servicegroups => "netservices";
    }
}
