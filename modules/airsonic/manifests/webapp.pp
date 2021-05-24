class airsonic::webapp {
    $port    = $airsonic::vars::port
    $proto   = "http"
    $rdomain = $airsonic::vars::rdomain
    if ($domain != $rdomain) {
	$reverse = "play.$rdomain"
	$aliases = [ $reverse ]
    } else {
	$reverse = false
	$aliases = false
    }

    if (defined(Class["apache"])) {
	apache::define::vhost {
	    "play.$domain":
		aliases         => $aliases,
		app_port        => $port,
		app_proto       => $proto,
		csp_name        => "airsonic",
		konami_location => $airsonic::vars::music_root,
		noerrors        => true,
		require         => Common::Define::Service["airsonic"],
		sslredirecthttp => true,
		stricttransport => "max-age=31536000; includeSubDomains; preload",
		vhostldapauth   => "applicative",
		vhostsource     => "app_proxy",
		with_reverse    => $reverse;
	}
    } else {
	include nginx

	nginx::define::vhost {
	    "play.$domain":
		aliases         => $aliases,
		app_port        => $port,
		app_proto       => $proto,
		csp_name        => "airsonic",
		deny_frames     => false,
		konami_location => $airsonic::vars::music_root,
		maxtempfilesize => 0,
		noerrors        => true,
		require         => Common::Define::Service["airsonic"],
		sslredirecthttp => true,
		stricttransport => "max-age=31536000; includeSubDomains; preload",
		vhostldapauth   => "applicative",
		vhostsource     => "app_proxy",
		with_reverse    => $reverse;
	}
    }
}
