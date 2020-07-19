class packages::rhel {
    $rdomain  = $packages::vars::rdomain
    $web_root = $packages::vars::web_root
    if ($domain != $rdomain) {
	$reverse = "rhel.$rdomain"
	$aliases = [ $reverse, "centos.$domain", "centos.$rdomain", "rhel", "centos" ]
    } else {
	$reverse = false
	$aliases = [ "centos.$domain", "centos.$rdomain", "rhel", "centos" ]
    }

    file {
	"Install rhel repository root":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$web_root/rhel",
	    require => File["Prepare www directory"];
	"Install rhel repository metadata generator":
	    content => template("packages/update_rpms.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/local/sbin/update_rpms";
    }

    if (defined(Class["apache"])) {
	apache::define::vhost {
	    "rhel.$domain":
		aliases      => $aliases,
		app_root     => "$web_root/rhel",
		csp_name     => "packages",
		pubclear     => true,
		require      => File["Install rhel repository root"],
		vhostsource  => "rhel",
		with_reverse => $reverse;
	}
    } else {
	nginx::define::vhost {
	    "rhel.$domain":
		aliases        => $aliases,
		app_root       => "$web_root/rhel",
		autoindex      => true,
		csp_name       => "packages",
		nohttpsrewrite => true,
		pubclear       => true,
		require        => File["Install rhel repository root"],
		vhostsource    => "rhel",
		with_reverse   => $reverse;
	}
    }
}
