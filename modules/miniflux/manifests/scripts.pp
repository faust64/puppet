class miniflux::scripts {
    $runtime_user = $miniflux::vars::runtime_user
    $web_root     = $miniflux::vars::web_root

    file {
	"Install miniflux update script":
	    content => template("miniflux/update.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/update_miniflux_subscriptions";
    }
}
