class btsync::vars {
    $default_secret = hiera("btsync_default_secret")
    $listen_addr    = hiera("btsync_listen_addr")
    $runtime_user   = hiera("btsync_runtime_user")
    $shared_folders = hiera("btsync_shared_folders")
    $umask          = hiera("btsync_sync_umask")
}
