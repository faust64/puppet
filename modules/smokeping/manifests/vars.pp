class smokeping::vars {
    $conf_dir     = lookup("smokeping_conf_dir")
    $netids       = lookup("office_netids")
    $rdomain      = lookup("root_domain")
    $share_dir    = lookup("smokeping_share_dir")
    $short_name   = lookup("smokeping_short_name")
    $targets      = lookup("smokeping_targets")
    $web_root     = lookup("apache_web_root")
}
