class transmission::nagios {
    nagios::define::probe {
	"transmission":
	    description   => "$fqdn transmission daemon",
	    pluginargs    => [ "-u", "transmission" ],
	    servicegroups => "netservices";
    }
}
