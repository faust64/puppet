class packages::openbsd {
    $rdomain  = $packages::vars::rdomain
    $web_root = $packages::vars::web_root
    if ($domain != $rdomain) {
	$reverse = "openbsd.$rdomain"
	$aliases = [ $reverse, "openbsd" ]
    } else {
	$reverse = false
	$aliases = [ "openbsd" ]
    }

    file {
	"Install openbsd repository root":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$web_root/openbsd",
	    require => File["Prepare www directory"];
	"Install openbsd sync script":
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/local/sbin/sync_openbsd",
	    source  => "puppet:///modules/packages/sync_openbsd";
    }

    if (defined(Class["apache"])) {
	apache::define::vhost {
	    "openbsd.$domain":
		aliases      => $aliases,
		app_root     => "$web_root/openbsd",
		csp_name     => "packages",
		pubclear     => true,
		require      => File["Install openbsd repository root"],
		with_reverse => $reverse;
	}
    } else {
	nginx::define::vhost {
	    "openbsd.$domain":
		aliases        => $aliases,
		app_root       => "$web_root/openbsd",
		autoindex      => true,
		csp_name       => "packages",
		noerrors       => true,
		nohttpsrewrite => true,
		pubclear       => true,
		require        => File["Install openbsd repository root"],
		with_reverse   => $reverse;
	}
    }
}
