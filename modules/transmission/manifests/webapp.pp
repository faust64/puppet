class transmission::webapp {
    $rdomain   = $transmission::vars::rdomain
    $store_dir = $transmission::vars::store_dir

    if ($hostname == "transmission") {
	$maliases = [ "$hostname.$rdomain" ]
    } else {
	$maliases = [ "$hostname.$rdomain", "transmission.$rdomain" ]
    }
    $daliases = [ "what.$rdomain", "torrents.$domain", "torrents.$rdomain" ]

    if (defined(Class[Apache])) {
	apache::define::vhost {
	    "transmission.$domain":
		aliases       => $maliases,
		app_port      => 9091,
		require       => Service[$transmission::vars::srvname],
		vhostldapauth => false,
		vhostsource   => "app_proxy",
		with_reverse  => "$hostname.$rdomain";
	    "what.$domain":
		aliases       => $daliases,
		app_root      => "$store_dir/downloads/complete",
		autoindex     => true,
		require       => File["Prepare completed downloads directory"],
		vhostldapauth => false,
		with_reverse  => "what.$rdomain";
	}
    } else {
	include nginx

	nginx::define::vhost {
	    "transmission.$domain":
		aliases       => $maliases,
		app_port      => 9091,
		require       => Service[$transmission::vars::srvname],
		vhostldapauth => false,
		vhostsource   => "app_proxy",
		with_reverse  => "$hostname.$rdomain";
	    "what.$domain":
		aliases       => $daliases,
		app_root      => "$store_dir/downloads/complete",
		autoindex     => true,
		require       => File["Prepare completed downloads directory"],
		vhostldapauth => false,
		with_reverse  => "what.$rdomain";
	}
    }
}
