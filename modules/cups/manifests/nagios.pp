class cups::nagios {
    if ($cups::vars::nagios_printers) {
	each($cups::vars::nagios_printers) |$printer| {
	    nagios::define::probe {
		"cups_printer_$printer":
		    description   => "$fqdn printer $printer",
		    pluginargs    => [ "-h", $cups::vars::listen_addr, "-p", $printer ],
		    pluginconf    => "printer",
		    servicegroups => "netservices",
		    use           => "jobs-service";
	    }
	}

	nagios::define::probe {
	    "cups_queue":
		description   => "$fqdn local print queue",
		pluginargs    => [ "-H", $cups::vars::listen_addr ],
		servicegroups => "netservices",
		use           => "warning-service";
	}
    } else {
	nagios::define::probe {
	    "cups_printer":
		description   => "$fqdn local printers",
		servicegroups => "netservices",
		use           => "jobs-service";
	    "cups_queue":
		dependency    => "$fqdn local printers",
		description   => "$fqdn local print queue",
		pluginargs    => [ "-H", $cups::vars::listen_addr ],
		servicegroups => "netservices",
		use           => "warning-service";
	}
    }
}
