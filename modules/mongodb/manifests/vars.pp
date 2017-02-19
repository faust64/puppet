class mongodb::vars {
    $backup_collections = hiera("mongodb_backup_collections")
    $backup_database    = hiera("mongodb_backup_database")
    $backup_dir         = hiera("mongodb_backup_dir")
    $conf_dir           = hiera("mongodb_conf_dir")
    $do_service         = hiera("mongodb_do_service")
    $dbpath             = hiera("mongodb_db_path")
    $journal            = hiera("mongodb_journal")
    $listen             = hiera("mongodb_listen_addr")
    $log_dir            = hiera("mongodb_log_dir")
    $log_retention      = hiera("mongodb_log_retention")
    $munin_monitored    = hiera("mongodb_munin")
    $munin_probes       = hiera("mongodb_munin_probes")
    $munin_service_name = hiera("munin_node_service_name")
    $nagios_databases   = hiera("mongodb_nagios_databases")
    $port               = hiera("mongodb_port")
    $runtime_group      = hiera("mongodb_runtime_group")
    $runtime_user       = hiera("mongodb_runtime_user")
}
