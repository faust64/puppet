class icinga::vars {
    $apache_conf_dir       = hiera("apache_conf_dir")
    $array_dom             = split($domain, '\.')
    $cache_dir             = hiera("icinga_cache_dir")
    $check_domains         = hiera("icinga_check_domains")
    $check_ssl             = hiera("icinga_check_ssl")
    $conf_dir              = hiera("icinga_conf_dir")
    $contact               = hiera("nagios_contact_escalate")
    $contact_alerts        = hiera("contact_alerts")
    $contact_alerts_icinga = hiera("contact_alerts_icinga")
    $contact_domain        = hiera("contact_domain")
    $devices               = hiera("icinga_static_devices")
    $dns_ip                = hiera("dns_ip")
    $download              = hiera("download_cmd")
    $lib_dir               = hiera("icinga_lib_dir")
    $livestatus_clients    = hiera("icinga_livestatus_clients")
    $log_dir               = hiera("icinga_log_dir")
    $nagios_conf_dir       = hiera("nagios_conf_dir")
    $nagios_contact_groups = hiera("nagios_contact_groups")
    $nagios_contacts       = hiera("nagios_contacts")
    $nagios_host_groups    = hiera("nagios_hostgroups")
    $plugins_dir           = hiera("nagios_plugins_dir")
    $rdomain               = hiera("root_domain")
    $repo                  = hiera("puppet_http_repo")
    $remote_collect        = hiera("icinga_collect_domains")
    $run_dir               = hiera("icinga_run_dir")
    $runtime_group         = hiera("nagios_runtime_group")
    $runtime_user          = hiera("nagios_runtime_user")
    $service_classes       = hiera("icinga_service_classes")
    $service_groups        = hiera("icinga_service_groups")
    $share_dir             = hiera("icinga_share_dir")
    $short_domain          = $array_dom[0]
    $slack_hook_uri        = hiera("icinga_slack_hook_uri")
    $sslscan_critical      = hiera("icinga_sslscan_critical_threshold")
    $sslscan_warning       = hiera("icinga_sslscan_warning_threshold")
    $web_group             = hiera("apache_runtime_group")
    $web_service           = hiera("apache_service_name")
    $web_user              = hiera("apache_runtime_user")
    $xinetd_service_name   = hiera("xinetd_service_name")

    if ($contact_alerts_icinga) {
	$alerts = $contact_alerts_icinga
    } else {
	$alerts = $contact_alerts
    }
    if (defined(Class[Pnp4nagios])) {
	$pnp = true
    } else { $pnp = false }
}
