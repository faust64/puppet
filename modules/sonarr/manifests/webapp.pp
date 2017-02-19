class sonarr::webapp {
    $rdomain = $sonarr::vars::rdomain

    $aliases = [ "nzbdrone.$rdomain", "nzbdrone.$domain" ]

    if (defined(Class["apache"])) {
	apache::define::vhost {
	    "sonarr.$domain":
		aliases       => $aliases,
		app_port      => 8989,
		csp_name      => "sonarr",
		deny_frames   => true,
		require       => Service["sonarr"],
		vhostldapauth => false,
		vhostsource   => "app_proxy",
		with_reverse  => "sonarr.$rdomain";
	}
    } else {
	include nginx

	nginx::define::vhost {
	    "sonarr.$domain":
		aliases       => $aliases,
		app_port      => 8989,
		csp_name      => "sonarr",
		deny_frames   => true,
		require       => Service["sonarr"],
		vhostldapauth => false,
		vhostsource   => "app_proxy",
		with_reverse  => "sonarr.$rdomain";
	}
    }
}
