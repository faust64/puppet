class icinga::servicegroups {
    if ($icinga::vars::service_groups) {
	create_resources(icinga::define::servicegroup,
			 $icinga::vars::service_groups)
    }
}
