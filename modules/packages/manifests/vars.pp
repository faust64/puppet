class packages::vars {
    $do_nfs   = hiera("packages_do_nfs")
    $rdomain  = hiera("root_domain")
    $web_root = hiera("apache_web_root")
}
