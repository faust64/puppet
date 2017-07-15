class icinga::vars {
    $apache_conf_dir       = lookup("apache_conf_dir")
    $array_dom             = split($domain, '\.')
    $cache_dir             = lookup("icinga_cache_dir")
    $check_domains         = lookup("icinga_check_domains")
    $check_ssl             = lookup("icinga_check_ssl")
    $conf_dir              = lookup("icinga_conf_dir")
    $contact               = lookup("nagios_contact_escalate")
    $contact_alerts        = lookup("contact_alerts")
    $contact_alerts_icinga = lookup("contact_alerts_icinga")
    $contact_domain        = lookup("contact_domain")
    $devices               = lookup("icinga_static_devices")
    $dns_ip                = lookup("dns_ip")
    $download              = lookup("download_cmd")
    $lib_dir               = lookup("icinga_lib_dir")
    $livestatus_clients    = lookup("icinga_livestatus_clients")
    $log_dir               = lookup("icinga_log_dir")
    $nagios_conf_dir       = lookup("nagios_conf_dir")
    $nagios_contact_groups = lookup("nagios_contact_groups")
    $nagios_contacts       = lookup("nagios_contacts")
    $nagios_host_groups    = lookup("nagios_hostgroups")
    $plugins_dir           = lookup("nagios_plugins_dir")
    $rdomain               = lookup("root_domain")
    $repo                  = lookup("puppet_http_repo")
    $remote_collect        = lookup("icinga_collect_domains")
    $run_dir               = lookup("icinga_run_dir")
    $runtime_group         = lookup("nagios_runtime_group")
    $runtime_user          = lookup("nagios_runtime_user")
    $service_classes       = lookup("icinga_service_classes")
    $service_groups        = lookup("icinga_service_groups")
    $share_dir             = lookup("icinga_share_dir")
    $short_domain          = $array_dom[0]
    $slack_hook_uri        = lookup("icinga_slack_hook_uri")
    $sslscan_critical      = lookup("icinga_sslscan_critical_threshold")
    $sslscan_warning       = lookup("icinga_sslscan_warning_threshold")
    $web_group             = lookup("apache_runtime_group")
    $web_service           = lookup("apache_service_name")
    $web_user              = lookup("apache_runtime_user")
    $xinetd_service_name   = lookup("xinetd_service_name")

    if ($contact_alerts_icinga) {
	$alerts = $contact_alerts_icinga
    } else {
	$alerts = $contact_alerts
    }
    if (defined(Class[Pnp4nagios])) {
	$pnp = true
    } else { $pnp = false }
}
