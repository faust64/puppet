class fail2ban::vars {
    $cache_ip             = lookup("squid_ip")
    $conf_dir             = lookup("fail2ban_conf_dir")
    $contact              = lookup("fail2ban_contact")
    $do_asterisk          = lookup("fail2ban_do_asterisk")
    $do_badbots           = lookup("fail2ban_do_badbots")
    $do_cpanel            = lookup("fail2ban_do_cpanel")
    $do_mail              = lookup("fail2ban_do_mails")
    $do_named             = lookup("fail2ban_do_named")
    $do_openvpn           = lookup("fail2ban_do_openvpn")
    $do_pam               = lookup("fail2ban_do_pam")
    $do_ssh               = lookup("fail2ban_do_ssh")
    $do_unbound           = lookup("fail2ban_do_unbound")
    $do_xinetd            = lookup("fail2ban_do_xinetd")
    $do_web_abuses        = lookup("fail2ban_do_web_abuses")
    $do_web_noscript      = lookup("fail2ban_do_web_noscript")
    $do_web_overflow      = lookup("fail2ban_do_web_overflow")
    $do_wordpress         = lookup("fail2ban_do_wordpress")
    $download             = lookup("download_cmd")
    $gid_adm              = lookup("gid_adm")
    $has_ssh_ddos         = lookup("fail2ban_ssh_ddos_filter")
    $ignoreips            = lookup("fail2ban_ignoreips")
    $maxretry             = lookup("fail2ban_maxretry")
    $munin_conf_dir       = lookup("munin_conf_dir")
    $munin_monitored      = lookup("fail2ban_munin")
    $munin_probes         = lookup("fail2ban_munin_probes")
    $munin_service_name   = lookup("munin_node_service_name")
    $named_log            = lookup("named_log_dir")
    $repo                 = lookup("puppet_http_repo")
    $rsyslog_conf_dir     = lookup("rsyslog_conf_dir")
    $rsyslog_service_name = lookup("rsyslog_service_name")
    $rsyslog_version      = lookup("rsyslog_version")
    $slack_hook           = lookup("fail2ban_slack_hook_uri")
    $ssh_port             = lookup("ssh_port")
    $version              = lookup("fail2ban_version")

    if ($do_web_abuses or $do_badbots) {
	if (defined(Class[Nginx]) or defined(Class[Bluemind]) or $hostname == "deepthroat") {
	    $web_path     = lookup("nginx_log_dir")
	} else {
	    $web_path     = lookup("apache_log_dir")
	}
	$web_logs         = "$web_path/*log"
    } else {
	$web_logs         = false
    }
}
