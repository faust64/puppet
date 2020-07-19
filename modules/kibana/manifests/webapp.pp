class kibana::webapp {
    $rdomain = $kibana::vars::rdomain
    if ($domain != $rdomain) {
	$reverse = "kibana.$rdomain"
	$aliases = [ $reverse ]
    } else {
	include apache

	$reverse = false
	$aliases = false
    }

    if (defined(Class["apache"])) {
	apache::define::vhost {
	    "kibana.$domain":
		aliases      => $aliases,
		app_port     => 5601,
		csp_name     => "kibana",
		require      => Common::Define::Service["kibana"],
		vhostsource  => "app_proxy",
		with_reverse => $reverse;
	}
    } else {
	include nginx

	nginx::define::vhost {
	    "kibana.$domain":
		aliases      => $aliases,
		app_port     => 5601,
		csp_name     => "kibana",
		require      => Common::Define::Service["kibana"],
		vhostsource  => "app_proxy",
		with_reverse => $reverse;
	}
    }
}
