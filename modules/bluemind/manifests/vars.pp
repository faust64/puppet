class bluemind::vars {
    $do_letsencrypt       = lookup("bluemind_letsencrypt")
    $do_prometheus        = lookup("bluemind_prometheus")
    $postfix_conf_dir     = lookup("postfix_conf_dir")
    $rsyslog_conf_dir     = lookup("rsyslog_conf_dir")
    $rsyslog_service_name = lookup("rsyslog_service_name")
}
