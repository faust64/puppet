class named::nagios {
    nagios::define::probe {
	"named":
	    description   => "$fqdn named",
	    pluginargs    =>
		[
		    "-s $ipaddress",
		    "-H $fqdn"
		],
	    pluginconf    => "dns",
	    servicegroups => "netservices";
    }
}
