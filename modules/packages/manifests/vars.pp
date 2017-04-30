class packages::vars {
    $do_nfs    = hiera("packages_do_nfs")
    $rdomain   = hiera("root_domain")
    $sync_hook = hiera("packages_sync_hook_uri")
    $web_root  = hiera("apache_web_root")
}
