class rsyslog::vars {
    $conf_dir        = lookup("rsyslog_conf_dir")
    $contact         = lookup("contact_alerts_rsyslog")
    $do_relp         = lookup("rsyslog_do_relp")
    $do_tcp          = lookup("rsyslog_do_tcp")
    $do_tls          = lookup("rsyslog_do_tls")
    $do_udp          = lookup("rsyslog_do_udp")
    $gid_adm         = lookup("gid_adm")
    $flt_contains    = lookup("rsyslog_filter_contains")
    $flt_regexp      = lookup("rsyslog_filter_regexp")
    $listen          = lookup("rsyslog_collect")
    $logstash_relp   = lookup("logstash_do_relp")
    $logstash_tcp    = lookup("logstash_do_tcp")
    $logstash_udp    = lookup("logstash_do_udp")
    $no_local_log    = lookup("rsyslog_discard_local_write")
    $ossec_mgr       = lookup("ossec_manager")
    $retransmit      = lookup("rsyslog_hub")
    $service_name    = lookup("rsyslog_service_name")
    $stunnel_srvname = lookup("stunnel_service_name")
    $store_dir       = lookup("rsyslog_store_dir")
    $store_esearch   = lookup("rsyslog_om_elasticsearch_target")
    $store_logstash  = lookup("rsyslog_logstash_target")
    $via_stunnel     = lookup("rsyslog_via_stunnel")

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
