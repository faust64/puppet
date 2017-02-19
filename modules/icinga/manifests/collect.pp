class icinga::collect {
    if ($icinga::vars::remote_collect) {
	each($icinga::vars::remote_collect) |$remote_domain| {
	    Nagios_host <<| tag == "nagios-$remote_domain" |>>
	    Nagios_service <<| tag == "nagios-$remote_domain" |>>
	    Nagios_servicedependency <<| tag == "nagios-$remote_domain" |>>
	    Nagios_serviceescalation <<| tag == "nagios-$remote_domain" |>>
	}
    } else {
	Nagios_host <<| tag == "nagios-$domain" |>>
	Nagios_service <<| tag == "nagios-$domain" |>>
	Nagios_servicedependency <<| tag == "nagios-$domain" |>>
	Nagios_serviceescalation <<| tag == "nagios-$domain" |>>
    }
}
