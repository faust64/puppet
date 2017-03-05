class tinytinyrss::webapp {
    $rdomain  = $tinytinyrss::vars::rdomain
    $web_root = $tinytinyrss::vars::web_root

    if ($domain != $rdomain) {
	$reverse = "tinytinyrss.$rdomain"
	$aliases = [ $reverse, "ttrss.$domain", "ttrss.$rdomain" ]
    } else {
	$reverse = false
	$aliases = [ "ttrss.$domain" ]
    }

    if (! defined(Class[Apache])) {
	include apache
    }
    if (! defined(Class[Mysql])) {
	include mysql
    }

    apache::define::vhost {
	"tinytinyrss.$domain":
	    aliases        => $aliases,
	    allow_override => "all",
	    app_root       => "$web_root/ttrss",
	    deny_frames    => false,
	    vhostldapauth  => "applicative",
	    with_reverse   => $reverse;
    }
}
