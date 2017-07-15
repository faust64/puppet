class riak::vars {
    $backend              = lookup("riak_backend")
    $backup_hour          = lookup("riak_backup_hour")
    $backup_minute        = lookup("riak_backup_minute")
    $backup_root          = lookup("riak_backup_remote_path")
    $backup_snap_size     = lookup("riak_backup_snap_size")
    $backup_ssh_port      = lookup("riak_backup_remote_ssh_port")
    $backup_target        = lookup("riak_backup_remote_host")
    $backup_user          = lookup("riak_backup_remote_user")
    $check_listen         = lookup("riak_listen")
    $ciphers              = lookup("riak_ciphers")
    $contact              = lookup("riak_contact")
    $db_drive             = lookup("riak_db_drive")
    $dcookie              = lookup("riak_dcookie")
    $define_buckets       = lookup("riak_bucket_types")
    $do_aae               = lookup("riak_do_aae")
    $do_control           = lookup("riak_do_control")
    $do_fullsync          = lookup("riak_do_fullsync")
    $do_riakcs_check      = lookup("riak_do_riakcs")
    $enterprise           = lookup("riak_enterprise")
    $fullsync_downgrade   = lookup("riak_fullsync_downgrade")
    $leveldb_compress     = lookup("riak_leveldb_compress")
    $lv                   = lookup("riak_lv")
    $max_memory_percent   = lookup("riak_max_memory_percent")
    $munin_basic          = lookup("riak_munin_basic")
    $munin_conf_dir       = lookup("munin_conf_dir")
    $munin_monitored      = lookup("riak_munin")
    $munin_probes         = lookup("riak_munin_probes")
    $munin_service_name   = lookup("munin_node_service_name")
    $nagios_conf_dir      = lookup("nagios_conf_dir")
    $nagios_local_pass    = lookup("riak_nagios_local_passphrase")
    $nagios_local_user    = lookup("riak_nagios_local_username")
    $nagios_remote_fqdn   = lookup("riak_nagios_remote_fqdn")
    $nagios_remote_pass   = lookup("riak_nagios_remote_passphrase")
    $nagios_remote_user   = lookup("riak_nagios_remote_username")
    $nagios_runtime_group = lookup("nagios_runtime_group")
    $nagios_runtime_user  = lookup("nagios_runtime_user")
    $port_http            = lookup("riak_port_http")
    $port_protobuf        = lookup("riak_port_protobuf")
    $register             = lookup("riak_register")
    $riak_ssl             = lookup("riak_ssl")
    $riakcs_version       = lookup("riakcs_version")
    $rsyslog_conf_dir     = lookup("rsyslog_conf_dir")
    $rsyslog_service_name = lookup("rsyslog_service_name")
    $rsyslog_version      = lookup("rsyslog_version")
    $runtime_group        = lookup("riak_runtime_group")
    $runtime_user         = lookup("riak_runtime_user")
    $security             = lookup("riak_security")
    $slack_hook           = lookup("riak_slack_hook_uri")
    $sudo_conf_dir        = lookup("sudo_conf_dir")
    $vg                   = lookup("riak_vg")
    $with_collectd        = lookup("riak_collectd")

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
