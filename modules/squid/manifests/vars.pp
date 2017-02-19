class squid::vars {
    $acl_domainblacklist  = hiera("squid_acl_noulldomain")
    $acl_domainnocache    = hiera("squid_exceptions")
    $acl_blacklist        = hiera("squid_acl_blacklist")
    $acl_ports            = hiera("squid_acl_ports")
    $acl_whitelist        = hiera("squid_acl_whitelist")
    $apt_cacher           = hiera("apt_cacher")
    $cache_dir            = hiera("squid_cache_dir")
    $cache_mem            = hiera("squid_cache_size")
    $cache_objsize_max    = hiera("squid_cache_objsize_max")
    $conf_dir             = hiera("squid_conf_dir")
    $contact_escalate     = hiera("contact_alerts")
    $error_dir            = hiera("squid_error_dir")
    $locale               = hiera("locale")
    $net_ids              = hiera("office_netids")
    $log_dir              = hiera("squid_log_dir")
    $nagios_runtime_user  = hiera("nagios_runtime_user")
    $root_domain          = hiera("root_domain")
    $rotate               = hiera("squid_rotate")
    $rsyslog_conf_dir     = hiera("rsyslog_conf_dir")
    $rsyslog_service_name = hiera("rsyslog_service_name")
    $runtime_group        = hiera("squid_runtime_group")
    $runtime_user         = hiera("squid_runtime_user")
    $service_name         = hiera("squid_service_name")
    $squid_command        = hiera("squid_command")
    $squid_rsyslog        = hiera("squid_rsyslog")
    $wat_do               = hiera("squid_wat_do")

    if ($root_domain != false) {
	$mydomain = $root_domain
    } else {
	$mydomain = $domain
    }
    $local_net_id         = $net_ids[$mydomain]
    $localnet             = inline_template("10.<%=@local_net_id%>.0.0/16")
}
