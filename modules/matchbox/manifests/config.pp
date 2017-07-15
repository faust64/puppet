class matchbox::config {
    $app_url      = $matchbox::vars::app_url
    $browser      = $matchbox::vars::preferred_browser
    $feed_url     = $matchbox::vars::feed_url
    $home_dir     = $matchbox::vars::home_dir
    $runtime_user = $matchbox::vars::runtime_user

    file {
	"Install matchbox xinitrc":
	    content => template("matchbox/xinitrc.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/boot/xinitrc";
	"Install matchbox rc.local":
	    content => template("matchbox/local.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/rc.local",
	    require => File["Install matchbox xinitrc"];
    }
}
