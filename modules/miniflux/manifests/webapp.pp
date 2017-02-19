class miniflux::webapp {
    $rdomain  = $miniflux::vars::rdomain
    $web_root = $miniflux::vars::web_root

    $aliases  = [ "miniflux.$rdomain" ]

    if (! defined(Class[Apache])) {
	include apache
    }
    if (! defined(Class[Sqlite])) {
	include sqlite
    }

    apache::define::vhost {
	"miniflux.$domain":
	    aliases        => $aliases,
	    allow_override => "all",
	    app_root       => "$web_root/miniflux",
	    vhostldapauth  => false,
	    with_reverse   => "miniflux.$rdomain";
    }
}
