class relayd::config {
    $conf_dir          = $relayd::vars::conf_dir
    $has_pixel         = $relayd::vars::has_pixel
    $mailmx_ip         = $relayd::vars::mailmx_ip
    $namecache_ip      = $relayd::vars::namecache_ip
    $pixel_ip          = $relayd::vars::pixel_ip
    $relayd_http_port  = $relayd::vars::relayd_http_port
    $relayd_https_port = $relayd::vars::relayd_https_port
    $relayd_interval   = $relayd::vars::relayd_interval
    $relayd_prefork    = $relayd::vars::relayd_prefork
    $relayd_timeout    = $relayd::vars::relayd_timeout
    $reverse_ip        = $relayd::vars::reverse_ip
    $webcache_ip       = $relayd::vars::webcache_ip

    file {
	"Relayd main configuration":
	    content => template("relayd/relayd.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0600",
	    notify  => Service["relayd"],
	    owner   => root,
	    path    => "$conf_dir/relayd.conf";
    }
}
