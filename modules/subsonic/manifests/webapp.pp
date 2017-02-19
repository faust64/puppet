class subsonic::webapp {
    $port    = 4040
    $proto   = "http"
    $rdomain = $subsonic::vars::rdomain
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
		csp_name        => "subsonic",
		konami_location => $subsonic::vars::music_root,
		require         => Service["subsonic"],
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
		csp_name        => "subsonic",
		deny_frames     => false,
		konami_location => $subsonic::vars::music_root,
		require         => Service["subsonic"],
		vhostldapauth   => "applicative",
		vhostsource     => "app_proxy",
		with_reverse    => $reverse;
	}
    }
}
