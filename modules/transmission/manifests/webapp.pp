class transmission::webapp {
    $rdomain   = $transmission::vars::rdomain
    $store_dir = $transmission::vars::store_dir

    if ($domain != $rdomain) {
	$reverse  = "transmission.$rdomain"
	$dreverse = "what.$rdomain"
	$aliases  = [ $reverse ]
	$daliases = [ $dreverse ]
    } else {
	include apache

	$reverse  = false
	$aliases  = false
	$daliases = false
	$dreverse = false
    }

    if (defined(Class["apache"])) {
	apache::define::vhost {
	    "seedbox.$domain":
		aliases       => $aliases,
		app_port      => 9091,
		noerrors      => true,
		require       => Common::Define::Service[$transmission::vars::srvname],
		vhostsource   => "app_proxy",
		with_reverse  => $reverse;
	    "what.$domain":
		aliases       => $daliases,
		app_root      => "$store_dir/downloads/complete",
		require       => File["Prepare completed downloads directory"],
		with_reverse  => $dreverse;
	}
    } else {
	include nginx

	nginx::define::vhost {
	    "seedbox.$domain":
		aliases       => $aliases,
		app_port      => 9091,
		noerrors      => true,
		require       => Common::Define::Service[$transmission::vars::srvname],
		vhostldapauth => false,
		vhostsource   => "app_proxy",
		with_reverse  => $reverse;
	    "what.$domain":
		aliases       => $daliases,
		app_root      => "$store_dir/downloads/complete",
		autoindex     => true,
		require       => File["Prepare completed downloads directory"],
		vhostldapauth => false,
		with_reverse  => $dreverse;
	}
    }
}
