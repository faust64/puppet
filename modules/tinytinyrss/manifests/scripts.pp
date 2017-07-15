class tinytinyrss::scripts {
    $runtime_user = $tinytinyrss::vars::runtime_user
    $web_root     = $tinytinyrss::vars::web_root

    file {
	"Install tinytinyrss update script":
	    content => template("tinytinyrss/update.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/update_tinytinyrss_subscriptions";
    }
}
