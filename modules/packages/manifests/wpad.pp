class packages::wpad {
    $rdomain  = $packages::vars::rdomain
    $web_root = $packages::vars::web_root
    if ($domain != $rdomain) {
	$reverse = "wpad.$rdomain"
	$aliases = [ $reverse, "wpad" ]
    } else {
	$reverse = false
	$aliases = [ "wpad" ]
    }

    file {
	"Install wpad repository root":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$web_root/wpad",
	    require => File["Prepare www directory"];
    }

    if (defined(Class[Apache])) {
	apache::define::vhost {
	    "wpad.$domain":
		aliases      => $aliases,
		app_root     => "$web_root/wpad",
		csp_name     => "packages",
		pubclear     => true,
		require      => File["Install wpad repository root"],
		with_reverse => $reverse;
	}
    } else {
	nginx::define::vhost {
	    "wpad.$domain":
		aliases        => $aliases,
		app_root       => "$web_root/wpad",
		autoindex      => true,
		csp_name       => "packages",
		nohttpsrewrite => true,
		pubclear       => true,
		require        => File["Install wpad repository root"],
		with_reverse   => $reverse;
	}
    }
}
