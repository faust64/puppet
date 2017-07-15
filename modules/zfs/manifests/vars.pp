class zfs::vars {
    $munin_conf_dir     = lookup("munin_conf_dir")
    $munin_fs_probes    = lookup("zfs_munin_fs_probes")
    $munin_monitored    = lookup("zfs_munin")
    $munin_probes       = lookup("zfs_munin_probes")
    $munin_service_name = lookup("munin_node_service_name")
    $munin_stats_probes = lookup("zfs_munin_stats_probes")
}
