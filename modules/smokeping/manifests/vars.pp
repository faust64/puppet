class smokeping::vars {
    $conf_dir     = hiera("smokeping_conf_dir")
    $netids       = hiera("office_netids")
    $rdomain      = hiera("root_domain")
    $share_dir    = hiera("smokeping_share_dir")
    $short_name   = hiera("smokeping_short_name")
    $targets      = hiera("smokeping_targets")
    $web_root     = hiera("apache_web_root")
}
