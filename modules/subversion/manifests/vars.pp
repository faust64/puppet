class subversion::vars {
    $apache_conf_dir = lookup("apache_conf_dir")
    $rdomain         = lookup("root_domain")
    $web_front       = lookup("subversion_web_front")
    $web_root        = lookup("apache_web_root")
}
