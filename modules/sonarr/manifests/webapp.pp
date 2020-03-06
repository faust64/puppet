class sonarr::webapp {
    $rdomain = $sonarr::vars::rdomain

    if ($domain != $rdomain) {
	$reverse = "sonarr.$rdomain"
	$aliases = [ $reverse, "nzbdrone.$domain", "nzbdrone.$rdomain" ]
    } else {
	$reverse = false
	$aliases = [ "nzbdrone.$domain" ]
    }

    if (defined(Class["apache"])) {
	apache::define::vhost {
	    "sonarr.$domain":
		aliases       => $aliases,
		app_port      => 8989,
		csp_name      => "sonarr",
		deny_frames   => true,
		require       => Common::Define::Service["sonarr"],
		vhostldapauth => false,
		vhostsource   => "app_proxy",
		with_reverse  => $reverse;
	}
    } else {
	include nginx

	nginx::define::vhost {
	    "sonarr.$domain":
		aliases       => $aliases,
		app_port      => 8989,
		csp_name      => "sonarr",
		deny_frames   => true,
		require       => Common::Define::Service["sonarr"],
		vhostldapauth => false,
		vhostsource   => "app_proxy",
		with_reverse  => $reverse;
	}
    }
}
