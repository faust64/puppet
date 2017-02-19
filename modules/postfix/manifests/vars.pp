class postfix::vars {
    $alias_dir            = hiera("mail_alias_dir")
    $bluemind_satellite   = hiera("bluemind_satellite")
    $check_myhostname     = hiera("postfix_myhostname")
    $conf_dir             = hiera("postfix_conf_dir")
    $do_letsencrypt       = hiera("postfix_letsencrypt")
    $local_domains        = hiera("postfix_local_domains")
    $mail_ip              = hiera("mail_ip")
    $mail_mx              = hiera("mail_mx")
    $mail_recipient       = hiera("mail_recipient")
    $masquerade           = hiera("postfix_smtp_generic_maps")
    $munin_conf_dir       = hiera("munin_conf_dir")
    $munin_monitored      = hiera("postfix_munin")
    $munin_probes         = hiera("postfix_munin_probes")
    $munin_service_name   = hiera("munin_node_service_name")
    $postfix_networks     = hiera("postfix_networks")
    $random_source        = hiera("random_source")
    $rbls                 = hiera("postfix_rbls")
    $routeto              = hiera("postfix_routeto")
    $rsyslog_conf_dir     = hiera("rsyslog_conf_dir")
    $rsyslog_service_name = hiera("rsyslog_service_name")
    $spamassassin_user    = hiera("spamassassin_runtime_user")
    $spool_dir            = hiera("postfix_spool_dir")

    if ($check_myhostname) {
	$myhostname = $check_myhostname
    } else {
	$myhostname = $fqdn
    }
}
