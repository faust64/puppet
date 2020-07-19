class packages::freebsd {
    $rdomain  = $packages::vars::rdomain
    $web_root = $packages::vars::web_root
    if ($domain != $rdomain) {
	$reverse = "freebsd.$rdomain"
	$aliases = [ $reverse, "mfsbsd.$domain", "mfsbsd.$rdomain", "freebsd", "mfsbsd" ]
    } else {
	$reverse = false
	$aliases = [ "mfsbsd.$domain", "freebsd", "mfsbsd" ]
    }

    file {
	"Install freebsd repository root":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$web_root/freebsd",
	    require => File["Prepare www directory"];
	"Install freebsd_build_latests scripts":
	    content => template("packages/freebsd_build_latests.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0751",
	    owner   => root,
	    path    => "/usr/local/sbin/freebsd_build_latests",
	    require => File["Install freebsd repository root"];
    }

    if (defined(Class["apache"])) {
	apache::define::vhost {
	    "freebsd.$domain":
		aliases      => $aliases,
		app_root     => "$web_root/freebsd",
		csp_name     => "packages",
		pubclear     => true,
		require      => File["Install freebsd repository root"],
		with_reverse => $reverse;
	}
    } else {
	nginx::define::vhost {
	    "freebsd.$domain":
		aliases        => $aliases,
		app_root       => "$web_root/freebsd",
		autoindex      => true,
		csp_name       => "packages",
		noerrors       => true,
		nohttpsrewrite => true,
		pubclear       => true,
		require        => File["Install freebsd repository root"],
		with_reverse   => $reverse;
	}
    }
}
