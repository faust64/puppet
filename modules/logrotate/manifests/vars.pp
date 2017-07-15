class logrotate::vars {
    $conf_dir  = lookup("logrotate_dir")
    $retention = lookup("logrotate_retention")
}
