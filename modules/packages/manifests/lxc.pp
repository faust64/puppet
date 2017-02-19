class packages::lxc {
    $rdomain  = $packages::vars::rdomain
    $web_root = $packages::vars::web_root
    if ($domain != $rdomain) {
	$reverse = "lxc.$rdomain"
	$aliases = [ $reverse, "lxc" ]
    } else {
	$reverse = false
	$aliases = [ "lxc" ]
    }

    file {
	"Install lxc repository root":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$web_root/lxc",
	    require => File["Prepare www directory"];
    }

    if (defined(Class[Apache])) {
	apache::define::vhost {
	    "lxc.$domain":
		aliases      => $aliases,
		app_root     => "$web_root/lxc",
		csp_name     => "packages",
		pubclear     => true,
		require      => File["Install lxc repository root"],
		with_reverse => $reverse;
	}
    } else {
	nginx::define::vhost {
	    "lxc.$domain":
		aliases        => $aliases,
		app_root       => "$web_root/lxc",
		autoindex      => true,
		csp_name       => "packages",
		noerrors       => true,
		nohttpsrewrite => true,
		pubclear       => true,
		require        => File["Install lxc repository root"],
		with_reverse   => $reverse;
	}
    }
}
