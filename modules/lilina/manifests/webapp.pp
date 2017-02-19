class lilina::webapp {
    $rdomain  = $lilina::rdomain
    $web_root = $lilina::vars::web_root

    $aliases   = [ "lilina.$rdomain" ]

    if (! defined(Class[Apache])) {
	include apache
    }

    apache::define::vhost {
	"lilina.$domain":
	    aliases        => $aliases,
	    allow_override => "all",
	    app_root       => "$web_root/lilina",
	    vhostldapauth => false,
	    with_reverse  => "lilina.$rdomain";
    }
}
