class btsync::vars {
    $default_secret = lookup("btsync_default_secret")
    $listen_addr    = lookup("btsync_listen_addr")
    $runtime_user   = lookup("btsync_runtime_user")
    $shared_folders = lookup("btsync_shared_folders")
    $umask          = lookup("btsync_sync_umask")
}
