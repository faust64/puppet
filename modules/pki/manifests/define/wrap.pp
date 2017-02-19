define pki::define::wrap($ca      = "web",
			 $do      = "all",
			 $prefix  = "server",
			 $reqfile = "Prepare apache ssl directory",
			 $within  = false) {
    if ($within != false) {
	if ($do == "ca") {
	    if (! defined(Pki::Define::Get["PKI $ca service chain"])) {
		pki::define::get {
		    "PKI $ca service chain":
			ca      => $ca,
			notify  => Service[$name],
			require => File[$reqfile],
			target  => $within,
			what    => "chain";
		}
	    }
	} else {
	    pki::define::get {
		"$fqdn $prefix certificate":
		    ca      => $ca,
		    notify  => Service[$name],
		    prefix  => $prefix,
		    require => File[$reqfile],
		    target  => $within,
		    what    => "certificate";
		"$fqdn $prefix key":
		    ca      => $ca,
		    notify  => Service[$name],
		    prefix  => $prefix,
		    require => Pki::Define::Get["$fqdn $prefix certificate"],
		    target  => $within,
		    what    => "key";
	    }

	    if (! defined(Pki::Define::Get["PKI $ca service chain"])) {
		pki::define::get {
		    "PKI $ca service chain":
			ca      => $ca,
			notify  => Service[$name],
			require => Pki::Define::Get["$fqdn $prefix key"],
			target  => $within,
			what    => "chain";
		}
	    }

	    if ($ca == "web") {
		exec {
		    "Concatenate dhparam to server certificate":
			command => "cat $prefix.crt dh.pem >dh$prefix.crt",
			creates => "$within/dh$prefix.crt",
			cwd     => $within,
			onlyif  => "test -s dh.pem",
			path    => "/usr/bin:/bin",
			require => Pki::Define::Get["$fqdn $prefix certificate"];
		}

		if (defined(Exec["Generate nginx dh.pem"])) {
		    Exec["Generate nginx dh.pem"]
			-> Exec["Concatenate dhparam to server certificate"]
		}
		if (defined(Exec["Generate apache dh.pem"])) {
		    Exec["Generate apache dh.pem"]
			-> Exec["Concatenate dhparam to server certificate"]
		}
	    }
	}
    }
}
