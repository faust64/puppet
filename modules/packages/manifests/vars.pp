class packages::vars {
    $do_nfs    = hiera("packages_do_nfs")
    $rdomain   = hiera("root_domain")
    $sync_hook = hiera("packages_sync_hook_uri")
    $sync_host = hiera("packages_sync_remote_host")
    $sync_path = hiera("packages_sync_remote_path")
    $sync_port = hiera("packages_sync_remote_port")
    $sync_user = hiera("packages_sync_remote_user")
    $web_root  = hiera("apache_web_root")
}
