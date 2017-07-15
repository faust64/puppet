class packages::vars {
    $do_nfs    = lookup("packages_do_nfs")
    $rdomain   = lookup("root_domain")
    $sync_hook = lookup("packages_sync_hook_uri")
    $sync_host = lookup("packages_sync_remote_host")
    $sync_path = lookup("packages_sync_remote_path")
    $sync_port = lookup("packages_sync_remote_port")
    $sync_user = lookup("packages_sync_remote_user")
    $web_root  = lookup("apache_web_root")
}
