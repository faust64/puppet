class icinga::serviceclasses {
    if ($icinga::vars::service_classes) {
	create_resources(icinga::define::serviceclass,
			 $icinga::vars::service_classes)
    }
}
