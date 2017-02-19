class rsync::vars {
    $clients             = hiera("rsync_clients")
    $conf_dir            = hiera("rsync_conf_dir")
    $service_name        = hiera("rsync_service_name")
    $shares              = hiera("rsync_shares")
}
