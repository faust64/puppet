class collection3::webapp {
    if (! defined(Class["apache"])) {
	include apache
    }

    $rdomain  = $collection3::vars::rdomain
    $web_root = $collection3::vars::web_root

    if ($domain == $rdomain) {
	$reverse = "collection.$rdomain"
	$aliases = [ $reverse, "collectd.$domain", "collectd.$rdomain" ]
    } else {
	$reverse = false
	$aliases = [ "collectd.$domain" ]
    }

    apache::define::vhost {
	"collection.$domain":
	    app_root       => "$web_root/collection3",
	    aliases        => $aliases,
	    allow_override => "None",
	    options        => "+ExecCGI",
	    vhostldapauth  => false,
	    vhostsource    => "collection",
	    with_reverse   => $reverse;
    }
}
