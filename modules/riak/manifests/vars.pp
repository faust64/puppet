class riak::vars {
    $backend              = hiera("riak_backend")
    $backup_hour          = hiera("riak_backup_hour")
    $backup_minute        = hiera("riak_backup_minute")
    $backup_root          = hiera("riak_backup_remote_path")
    $backup_snap_size     = hiera("riak_backup_snap_size")
    $backup_ssh_port      = hiera("riak_backup_remote_ssh_port")
    $backup_target        = hiera("riak_backup_remote_host")
    $backup_user          = hiera("riak_backup_remote_user")
    $ciphers              = hiera("riak_ciphers")
    $contact              = hiera("riak_contact")
    $define_buckets       = hiera("riak_bucket_types")
    $check_listen         = hiera("riak_listen")
    $db_drive             = hiera("riak_db_drive")
    $dcookie              = hiera("riak_dcookie")
    $do_aae               = hiera("riak_do_aae")
    $do_control           = hiera("riak_do_control")
    $do_fullsync          = hiera("riak_do_fullsync")
    $do_riakcs_check      = hiera("riak_do_riakcs")
    $enterprise           = hiera("riak_enterprise")
    $fullsync_downgrade   = hiera("riak_fullsync_downgrade")
    $leveldb_compress     = hiera("riak_leveldb_compress")
    $lv                   = hiera("riak_lv")
    $max_memory_percent   = hiera("riak_max_memory_percent")
    $munin_basic          = hiera("riak_munin_basic")
    $munin_conf_dir       = hiera("munin_conf_dir")
    $munin_monitored      = hiera("riak_munin")
    $munin_probes         = hiera("riak_munin_probes")
    $munin_service_name   = hiera("munin_node_service_name")
    $nagios_conf_dir      = hiera("nagios_conf_dir")
    $nagios_local_pass    = hiera("riak_nagios_local_passphrase")
    $nagios_local_user    = hiera("riak_nagios_local_username")
    $nagios_remote_fqdn   = hiera("riak_nagios_remote_fqdn")
    $nagios_remote_pass   = hiera("riak_nagios_remote_passphrase")
    $nagios_remote_user   = hiera("riak_nagios_remote_username")
    $nagios_runtime_group = hiera("nagios_runtime_group")
    $nagios_runtime_user  = hiera("nagios_runtime_user")
    $port_http            = hiera("riak_port_http")
    $port_protobuf        = hiera("riak_port_protobuf")
    $register             = hiera("riak_register")
    $riak_ssl             = hiera("riak_ssl")
    $riakcs_version       = hiera("riakcs_version")
    $rsyslog_conf_dir     = hiera("rsyslog_conf_dir")
    $rsyslog_service_name = hiera("rsyslog_service_name")
    $rsyslog_version      = hiera("rsyslog_version")
    $runtime_group        = hiera("riak_runtime_group")
    $runtime_user         = hiera("riak_runtime_user")
    $security             = hiera("riak_security")
    $slack_hook           = hiera("riak_slack_hook_uri")
    $sudo_conf_dir        = hiera("sudo_conf_dir")
    $vg                   = hiera("riak_vg")
    $with_collectd        = hiera("riak_collectd")

    if ($check_listen == false) {
	$listen = $ipaddress
    } else {
	$listen = $check_listen
    }
    if (defined(Class[Riakcs])) {
	$do_riakcs = true
    } else {
	$do_riakcs = $do_riakcs_check
    }

    $nodename = "$dcookie@$listen"
}
