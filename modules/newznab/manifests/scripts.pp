class newznab::scripts {
    $contact    = $newznab::vars::contact
    $slack_hook = $newznab::vars::slack_hook
    $web_root   = $newznab::vars::web_root

    file {
	"Install newznab update script":
	    content => template("newznab/update.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0700",
	    owner   => root,
	    path    => "/usr/local/sbin/newznab_update",
	    require => File["Install Newznab main configuration"];
    }
}
