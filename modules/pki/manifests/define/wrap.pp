define pki::define::wrap($ca      = "web",
			 $do      = "all",
			 $owner   = false,
			 $group   = false,
			 $mode    = false,
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

	    if ($owner) {
		exec {
		    "Set proper owner to $fqdn $prefix key":
			command => "chown $owner $prefix.key",
			cwd     => $within,
			path    => "/usr/bin:/bin",
			require => Pki::Define::Get["$fqdn $prefix key"],
			unless  => "stat -c %U $prefix.key | grep $owner";
		}
	    }
	    if ($group) {
		exec {
		    "Set proper group to $fqdn $prefix key":
			command => "chown :$group $prefix.key",
			cwd     => $within,
			path    => "/usr/bin:/bin",
			require => Pki::Define::Get["$fqdn $prefix key"],
			unless  => "stat -c %G $prefix.key | grep $group";
		}
	    }
	    if ($mode) {
		exec {
		    "Set proper permissions to $fqdn $prefix key":
			command => "chmod $mode $prefix.key",
			cwd     => $within,
			path    => "/usr/bin:/bin",
			require => Pki::Define::Get["$fqdn $prefix key"],
			unless  => "stat -c 0%a $prefix.key | grep $mode";
		}
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
		    "Concatenate dhparam to $prefix certificate":
			command => "cat $prefix.crt dh.pem >dh$prefix.crt",
			creates => "$within/dh$prefix.crt",
			cwd     => $within,
			onlyif  => "test -s dh.pem",
			path    => "/usr/bin:/bin",
			require => Pki::Define::Get["$fqdn $prefix certificate"];
		}

		if (defined(Exec["Generate nginx dh.pem"])) {
		    Exec["Generate nginx dh.pem"]
			-> Exec["Concatenate dhparam to $prefix certificate"]
		}
		if (defined(Exec["Generate apache dh.pem"])) {
		    Exec["Generate apache dh.pem"]
			-> Exec["Concatenate dhparam to $prefix certificate"]
		}

		if ($owner) {
		    exec {
			"Set proper owner to $fqdn $prefix dh concatenation":
			    command => "chown $owner dh$prefix.crt",
			    cwd     => $within,
			    path    => "/usr/bin:/bin",
			    require => Exec["Concatenate dhparam to $prefix certificate"],
			    unless  => "stat -c %U dh$prefix.crt | grep $owner";
		    }
		}
		if ($group) {
		    exec {
			"Set proper group to $fqdn $prefix dh concatenation":
			    command => "chown :$group dh$prefix.crt",
			    cwd     => $within,
			    path    => "/usr/bin:/bin",
			    require => Exec["Concatenate dhparam to $prefix certificate"],
			    unless  => "stat -c %G dh$prefix.crt | grep $group";
		    }
		}
		if ($mode) {
		    exec {
			"Set proper permissions to $fqdn $prefix dh concatenation":
			    command => "chmod $mode dh$prefix.crt",
			    cwd     => $within,
			    path    => "/usr/bin:/bin",
			    require => Exec["Concatenate dhparam to $prefix certificate"],
			    unless  => "stat -c 0%a dh$prefix.crt | grep $mode";
		    }
		}
	    }
	}
    }
}
