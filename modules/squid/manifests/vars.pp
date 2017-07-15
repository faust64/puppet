class squid::vars {
    $acl_domainblacklist  = lookup("squid_acl_noulldomain")
    $acl_domainnocache    = lookup("squid_exceptions")
    $acl_blacklist        = lookup("squid_acl_blacklist")
    $acl_ports            = lookup("squid_acl_ports")
    $acl_whitelist        = lookup("squid_acl_whitelist")
    $apt_cacher           = lookup("apt_cacher")
    $cache_dir            = lookup("squid_cache_dir")
    $cache_mem            = lookup("squid_cache_size")
    $cache_objsize_max    = lookup("squid_cache_objsize_max")
    $conf_dir             = lookup("squid_conf_dir")
    $contact_escalate     = lookup("contact_alerts")
    $error_dir            = lookup("squid_error_dir")
    $locale               = lookup("locale")
    $net_ids              = lookup("office_netids")
    $log_dir              = lookup("squid_log_dir")
    $nagios_runtime_user  = lookup("nagios_runtime_user")
    $root_domain          = lookup("root_domain")
    $rotate               = lookup("squid_rotate")
    $rsyslog_conf_dir     = lookup("rsyslog_conf_dir")
    $rsyslog_service_name = lookup("rsyslog_service_name")
    $runtime_group        = lookup("squid_runtime_group")
    $runtime_user         = lookup("squid_runtime_user")
    $service_name         = lookup("squid_service_name")
    $squid_command        = lookup("squid_command")
    $squid_rsyslog        = lookup("squid_rsyslog")
    $wat_do               = lookup("squid_wat_do")

    if ($root_domain != false) {
	$mydomain = $root_domain
    } else {
	$mydomain = $domain
    }
    $local_net_id         = $net_ids[$mydomain]
    $localnet             = inline_template("10.<%=@local_net_id%>.0.0/16")
}
