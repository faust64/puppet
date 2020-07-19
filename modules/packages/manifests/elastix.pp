class packages::elastix {
    $rdomain  = $packages::vars::rdomain
    $web_root = $packages::vars::web_root
    if ($domain != $rdomain) {
	$reverse = "elastix.$rdomain"
	$aliases = [ $reverse, "elastix" ]
    } else {
	$reverse = false
	$aliases = false
    }

    file {
	"Install elastix repository root":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$web_root/elastix",
	    require => File["Prepare www directory"];
    }

    if (defined(Class["apache"])) {
	apache::define::vhost {
	    "elastix.$domain":
		aliases      => $aliases,
		app_root     => "$web_root/elastix",
		csp_name     => "packages",
		pubclear     => true,
		require      => File["Install elastix repository root"],
		with_reverse => $reverse;
	}
    } else {
	nginx::define::vhost {
	    "elastix.$domain":
		aliases        => $aliases,
		app_root       => "$web_root/elastix",
		autoindex      => true,
		csp_name       => "packages",
		noerrors       => true,
		nohttpsrewrite => true,
		pubclear       => true,
		require        => File["Install elastix repository root"],
		with_reverse   => $reverse;
	}
    }
}
