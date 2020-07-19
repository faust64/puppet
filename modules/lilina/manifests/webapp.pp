class lilina::webapp {
    $rdomain  = $lilina::rdomain
    $web_root = $lilina::vars::web_root

    if ($domain != $rdomain) {
	$reverse = "lilina.$rdomain"
	$aliases = [ $reverse ]
    } else {
	$reverse = false
	$aliases = false
    }

    if (! defined(Class["apache"])) {
	include apache
    }

    apache::define::vhost {
	"lilina.$domain":
	    aliases        => $aliases,
	    allow_override => "all",
	    app_root       => "$web_root/lilina",
	    vhostldapauth  => false,
	    with_reverse   => $reverse;
    }
}
