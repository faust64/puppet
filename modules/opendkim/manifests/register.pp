class opendkim::register {
    $conf_dir = $opendkim::vars::conf_dir

    each($opendkim::vars::sign) |$dom| {
	$sdkimprivate = "dkim_private_${dom}"
	$sdkimtxt     = "dkim_txt_${dom}"
	$dkimprivate  = inline_template("<%=scope.lookupvar(@sdkimprivate)%>")
	$dkimtxt      = inline_template("<%=scope.lookupvar(@sdkimtxt)%>")

	if ($dkimprivate) {
	    @@opendkim::define::keydir {
		"Synchronized $dom":
		    mydomain => "$dom",
		    tag      => "opendkim-$dom";
	    }

	    @@file {
		"Replicate $dom DKIM private key":
		    content => "$dkimprivate
",
		    group   => $opendkim::vars::runtime_group,
		    mode    => "0600",
		    owner   => $opendkim::vars::runtime_user,
		    path    => "$conf_dir/dkim.d/keys/$dom/default.private",
		    require => File["Prepare opendkim $dom keys directory"],
		    tag     => "opendkim-$dom";
	    }
	}

	if ($dkimtxt) {
	    @@common::define::lined {
		"Install $dom DKIM TXT record (private-view)":
		    line   => $dkimtxt,
		    match  => "^default._domainkey",
		    notify => Exec["Update DNS configuration"],
		    path   => "/usr/share/dnsgen/private-view.d/db.$dom",
		    tag    => "opendkim-$dom";
		"Install $dom DKIM TXT record (public-view)":
		    line   => $dkimtxt,
		    match  => "^default._domainkey",
		    notify => Exec["Update DNS configuration"],
		    path   => "/usr/share/dnsgen/public-view.d/db.$dom",
		    tag    => "opendkim-$dom";
	    }
	}
    }
}
