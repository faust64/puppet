class rsync::vars {
    $clients      = lookup("rsync_clients")
    $conf_dir     = lookup("rsync_conf_dir")
    $service_name = lookup("rsync_service_name")
    $shares       = lookup("rsync_shares")
}
