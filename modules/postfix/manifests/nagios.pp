class postfix::nagios {
    if ($srvtype == "mail") {
	nagios::define::probe {
	    "smtps":
		description   => "$fqdn smtps",
		pluginargs    =>
		    [
			"-H 127.0.0.1",
			"-F $fqdn",
			"-p 465"
		    ],
		pluginconf    => "smtp",
		servicegroups => "netservices";
	    "submission":
		description   => "$fqdn submission",
		pluginargs    =>
		    [
			"-H 127.0.0.1",
			"-F $fqdn",
			"-p 587"
		    ],
		pluginconf    => "smtp",
		servicegroups => "netservices";
	}
    }

    nagios::define::probe {
	"postfix":
	    description   => "$fqdn postfix",
	    servicegroups => "netservices",
	    use           => "jobs-service";
    }
}
