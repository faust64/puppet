class packages::sles {
    $rdomain  = $packages::vars::rdomain
    $web_root = $packages::vars::web_root
    if ($domain != $rdomain) {
	$reverse = "sles.$rdomain"
	$aliases = [ $reverse, "sles" ]
    } else {
	$reverse = false
	$aliases = [ "sles" ]
    }

    file {
	"Install sles repository root":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$web_root/sles",
	    require => File["Prepare www directory"];
    }

    if (defined(Class[Apache])) {
	apache::define::vhost {
	    "sles.$domain":
		aliases      => $aliases,
		app_root     => "$web_root/sles",
		csp_name     => "packages",
		pubclear     => true,
		require      => File["Install sles repository root"],
		with_reverse => $reverse;
	}
    } else {
	nginx::define::vhost {
	    "sles.$domain":
		aliases        => $aliases,
		app_root       => "$web_root/sles",
		autoindex      => true,
		csp_name       => "packages",
		nohttpsrewrite => true,
		pubclear       => true,
		require        => File["Install sles repository root"],
		with_reverse   => $reverse;
	}
    }
}
