class bluemind::vars {
    $do_letsencrypt       = hiera("bluemind_letsencrypt")
    $postfix_conf_dir     = hiera("postfix_conf_dir")
    $rsyslog_conf_dir     = hiera("rsyslog_conf_dir")
    $rsyslog_service_name = hiera("rsyslog_service_name")
}
