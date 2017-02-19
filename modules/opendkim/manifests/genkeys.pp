class opendkim::genkeys {
    each($opendkim::vars::sign) |$dom| {
	opendkim::define::key {
	    $dom:
	}
    }
}
