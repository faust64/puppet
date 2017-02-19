class unbound::nagios {
    nagios::define::probe {
	"unbound":
	    description   => "$fqdn unbound",
	    pluginargs    =>
		[
		    "-s $ipaddress",
		    "-H $fqdn"
		],
	    pluginconf    => "dns",
	    servicegroups => "netservices";
    }
}
