class packages::default {
    $rdomain  = $packages::vars::rdomain
    $web_root = $packages::vars::web_root
    if ($domain != $rdomain) {
	$reverse = "repository.$rdomain"
	$aliases = [ "_", "packages.$domain", "packages.$rdomain", "packages.faust.intra.unetresgrossebite.com", "packages.vms.intra.unetresgrossebite.com", "packages",
		     $reverse, "repository.faust.intra.unetresgrossebite.com", "repository.vms.intra.unetresgrossebite.com", "repository" ]
    } else {
	$reverse = false
	$aliases = [ "_", "packages.$domain", "packages.$rdomain", "packages.faust.intra.unetresgrossebite.com", "packages.vms.intra.unetresgrossebite.com", "packages",
		     "repository.faust.intra.unetresgrossebite.com", "repository.vms.intra.unetresgrossebite.com", "repository" ]
    }

    file {
	"Install VMs default authorized keys":
	    owner   => root,
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    path    => "$web_root/authorized_keys",
	    require => File["Prepare www directory"],
	    source  => "puppet:///modules/packages/authorized_keys";
    }

    if (defined(Class[Apache])) {
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

    if ($packages::vars::do_nfs) {
	nfs::define::share {
	    "VE models":
		path => "$web_root/modeles",
		to   => [ "10.42.42.0/24", "10.42.46.0/24", "10.42.242.0/24" ];
	}
    }
}
