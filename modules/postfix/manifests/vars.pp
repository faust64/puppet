class postfix::vars {
    $alias_dir            = lookup("mail_alias_dir")
    $bluemind_satellite   = lookup("bluemind_satellite")
    $check_myhostname     = lookup("postfix_myhostname")
    $conf_dir             = lookup("postfix_conf_dir")
    $do_letsencrypt       = lookup("postfix_letsencrypt")
    $local_domains        = lookup("postfix_local_domains")
    $mail_ip              = lookup("mail_ip")
    $mail_mx              = lookup("mail_mx")
    $mail_recipient       = lookup("mail_recipient")
    $masquerade           = lookup("postfix_smtp_generic_maps")
    $munin_conf_dir       = lookup("munin_conf_dir")
    $munin_monitored      = lookup("postfix_munin")
    $munin_probes         = lookup("postfix_munin_probes")
    $munin_service_name   = lookup("munin_node_service_name")
    $postfix_networks     = lookup("postfix_networks")
    $random_source        = lookup("random_source")
    $rbls                 = lookup("postfix_rbls")
    $routeto              = lookup("postfix_routeto")
    $rsyslog_conf_dir     = lookup("rsyslog_conf_dir")
    $rsyslog_service_name = lookup("rsyslog_service_name")
    $spamassassin_user    = lookup("spamassassin_runtime_user")
    $spool_dir            = lookup("postfix_spool_dir")
    $tls_protos           = lookup("postfix_tls_mandatory_protocols")

    if ($check_myhostname) {
	$myhostname = $check_myhostname
    } else {
	$myhostname = $fqdn
    }
}
