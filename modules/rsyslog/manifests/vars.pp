class rsyslog::vars {
    $conf_dir        = hiera("rsyslog_conf_dir")
    $contact         = hiera("contact_alerts_rsyslog")
    $do_relp         = hiera("rsyslog_do_relp")
    $do_tcp          = hiera("rsyslog_do_tcp")
    $do_tls          = hiera("rsyslog_do_tls")
    $do_udp          = hiera("rsyslog_do_udp")
    $gid_adm         = hiera("gid_adm")
    $flt_contains    = hiera("rsyslog_filter_contains")
    $flt_regexp      = hiera("rsyslog_filter_regexp")
    $listen          = hiera("rsyslog_collect")
    $logstash_relp   = hiera("logstash_do_relp")
    $logstash_tcp    = hiera("logstash_do_tcp")
    $logstash_udp    = hiera("logstash_do_udp")
    $no_local_log    = hiera("rsyslog_discard_local_write")
    $ossec_mgr       = hiera("ossec_manager")
    $retransmit      = hiera("rsyslog_hub")
    $service_name    = hiera("rsyslog_service_name")
    $stunnel_srvname = hiera("stunnel_service_name")
    $store_dir       = hiera("rsyslog_store_dir")
    $store_esearch   = hiera("rsyslog_om_elasticsearch_target")
    $store_logstash  = hiera("rsyslog_logstash_target")
    $via_stunnel     = hiera("rsyslog_via_stunnel")

    if ($ossec_mgr == false) {
	$do_ossec = true
    } else {
	$do_ossec = false
    }
    if ($no_local_log) {
	$do_not_store = false
    } else {
	$do_not_store = true
    }
}
