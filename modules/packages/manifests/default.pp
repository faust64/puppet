class packages::default {
    $rdomain  = $packages::vars::rdomain
    $web_root = $packages::vars::web_root
    if ($domain != $rdomain) {
	$reverse = "repository.$rdomain"
	$aliases = [ "_", $reverse, "repository" ]
    } else {
	$reverse = false
	$aliases = [ "_", "repository" ]
    }

    file {
	"Install VMs default authorized keys":
	    owner   => root,
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    path    => "$web_root/authorized_keys",
	    require => File["Prepare www directory"],
	    source  => "puppet:///modules/packages/authorized_keys";
    }

    if (defined(Class["apache"])) {
	apache::define::vhost {
	    "repository.$domain":
		aliases      => $aliases,
		app_root     => $web_root,
		csp_name     => "packages",
		pubclear     => true,
		require      => File["Prepare www directory"],
		with_reverse => $reverse;
	}
    } else {
	nginx::define::vhost {
	    "repository.$domain":
		aliases        => $aliases,
		app_root       => $web_root,
		autoindex      => true,
		csp_name       => "packages",
		noerrors       => true,
		nohttpsrewrite => true,
		pubclear       => true,
		require        => File["Prepare www directory"],
		with_reverse   => $reverse;
	}
    }

    if ($packages::vars::do_nfs and $packages::vars::nfs_allow) {
	nfs::define::share {
	    "VE models":
		path => "$web_root/modeles",
		to   => $packages::vars::nfs_allow;
	}
    }
}
