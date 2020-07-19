class miniflux::webapp {
    $rdomain  = $miniflux::vars::rdomain
    $web_root = $miniflux::vars::web_root

    if ($domain != $rdomain) {
	$reverse = "miniflux.$rdomain"
	$aliases = [ $reverse ]
    } else {
	$reverse = false
	$aliases = false
    }

    if (! defined(Class["apache"])) {
	include apache
    }
    if (! defined(Class["sqlite"])) {
	include sqlite
    }

    apache::define::vhost {
	"miniflux.$domain":
	    aliases        => $aliases,
	    allow_override => "all",
	    app_root       => "$web_root/miniflux",
	    vhostldapauth  => false,
	    with_reverse   => $reverse;
    }
}
