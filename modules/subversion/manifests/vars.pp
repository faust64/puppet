class subversion::vars {
    $apache_conf_dir = hiera("apache_conf_dir")
    $rdomain         = hiera("root_domain")
    $web_front       = hiera("subversion_web_front")
    $web_root        = hiera("apache_web_root")
}
