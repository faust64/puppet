class nsd::nagios {
    nagios::define::probe {
	"nsd":
	    description   => "$fqdn nsd",
	    pluginargs    =>
		[
		    "-s $ipaddress",
		    "-H $fqdn"
		],
	    pluginconf    => "dns",
	    servicegroups => "netservices";
    }
}
