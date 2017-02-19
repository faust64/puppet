class smokeping::webapp {
    $rdomain = $smokeping::vars::rdomain
    $sname   = $smokeping::vars::short_name
    if ($domain != $rdomain) {
	$reverse = "$sname.$rdomain"
	$aliases = [ $reverse ]
    } else {
	$reverse = false
	$aliases = false
    }

    if (defined(Class["nginx"])) {
	nginx::define::vhost {
	    "smokeping.$domain":
		aliases       => $aliases,
		csp_name      => "smokeping",
		vhostldapauth => false,
		vhostsource   => "smokeping",
		with_reverse  => $reverse;
	}
    } else {
	if (! defined(Class["apache"])) {
	    include apache
	}

	apache::define::vhost {
	    "smokeping.$domain":
		aliases       => $aliases,
		csp_name      => "smokeping",
		vhostldapauth => false,
		vhostsource   => "smokeping",
		with_reverse  => $reverse;
	}
    }
}
