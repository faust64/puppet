class fail2ban::vars {
    $cache_ip             = hiera("squid_ip")
    $conf_dir             = hiera("fail2ban_conf_dir")
    $contact              = hiera("fail2ban_contact")
    $do_asterisk          = hiera("fail2ban_do_asterisk")
    $do_badbots           = hiera("fail2ban_do_badbots")
    $do_cpanel            = hiera("fail2ban_do_cpanel")
    $do_mail              = hiera("fail2ban_do_mails")
    $do_named             = hiera("fail2ban_do_named")
    $do_openvpn           = hiera("fail2ban_do_openvpn")
    $do_pam               = hiera("fail2ban_do_pam")
    $do_ssh               = hiera("fail2ban_do_ssh")
    $do_unbound           = hiera("fail2ban_do_unbound")
    $do_xinetd            = hiera("fail2ban_do_xinetd")
    $do_web_abuses        = hiera("fail2ban_do_web_abuses")
    $do_web_noscript      = hiera("fail2ban_do_web_noscript")
    $do_web_overflow      = hiera("fail2ban_do_web_overflow")
    $do_wordpress         = hiera("fail2ban_do_wordpress")
    $download             = hiera("download_cmd")
    $gid_adm              = hiera("gid_adm")
    $ignoreips            = hiera("fail2ban_ignoreips")
    $maxretry             = hiera("fail2ban_maxretry")
    $munin_conf_dir       = hiera("munin_conf_dir")
    $munin_monitored      = hiera("fail2ban_munin")
    $munin_probes         = hiera("fail2ban_munin_probes")
    $munin_service_name   = hiera("munin_node_service_name")
    $named_log            = hiera("named_log_dir")
    $repo                 = hiera("puppet_http_repo")
    $rsyslog_conf_dir     = hiera("rsyslog_conf_dir")
    $rsyslog_service_name = hiera("rsyslog_service_name")
    $rsyslog_version      = hiera("rsyslog_version")
    $slack_hook           = hiera("fail2ban_slack_hook_uri")
    $ssh_port             = hiera("ssh_port")
    $version              = hiera("fail2ban_version")

    if ($do_web_abuses or $do_badbots) {
	if (defined(Class[Nginx]) or defined(Class[Bluemind]) or $hostname == "deepthroat") {
	    $web_path     = hiera("nginx_log_dir")
	} else {
	    $web_path     = hiera("apache_log_dir")
	}
	$web_logs         = "$web_path/*log"
    } else {
	$web_logs         = false
    }
}
