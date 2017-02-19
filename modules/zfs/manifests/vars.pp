class zfs::vars {
    $munin_conf_dir     = hiera("munin_conf_dir")
    $munin_fs_probes    = hiera("zfs_munin_fs_probes")
    $munin_monitored    = hiera("zfs_munin")
    $munin_probes       = hiera("zfs_munin_probes")
    $munin_service_name = hiera("munin_node_service_name")
    $munin_stats_probes = hiera("zfs_munin_stats_probes")
}
