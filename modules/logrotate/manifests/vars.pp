class logrotate::vars {
    $conf_dir  = hiera("logrotate_dir")
    $retention = hiera("logrotate_retention")
}
