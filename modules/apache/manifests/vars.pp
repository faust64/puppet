class apache::vars {
    $all_networks         = hiera_hash("vlan_database")
    $allow_privates       = hiera("apache_allow_privates")
    $apache_debugs        = hiera("apache_debugs")
    $apache_rsyslog       = hiera("apache_rsyslog")
    $charset              = hiera("locale_charset")
    $conf_dir             = hiera("apache_conf_dir")
    $conf_file            = hiera("apache_conf_file")
    $csp_policies         = hiera("csp_policy_inventory")
    $csp_report           = hiera("csp_report")
    $csp_sources          = hiera("csp_sources")
    $download             = hiera("download_cmd")
    $do_letsencrypt       = hiera("apache_letsencrypt")
    $keepalive            = hiera("apache_keepalive")
    $keepalive_timeout    = hiera("apache_keepalive_timeout")
    $error_dir            = hiera("apache_error_dir")
    $hpkp_max_age         = hiera("hpkp_max_age")
    $hpkp_report          = hiera("hpkp_report")
    $icons_dir            = hiera("apache_icons_dir")
    $ldap_slave_check     = hiera("openldap_ldap_slave")
    $listen_ports         = hiera("apache_listen_ports")
    $local_networks       = hiera("active_vlans")
    $log_dir              = hiera("apache_log_dir")
    $log_group            = hiera("gid_adm")
    $log_user             = "root"
    $maintenance          = hiera("apache_maintenance")
    $max_keepalive_req    = hiera("apache_max_keepalive_req")
    $modules_dir          = hiera("apache_modules_dir")
    $mod_actions          = hiera("apache_mod_actions")
    $mod_alias            = hiera("apache_mod_alias")
    $mod_autoindex        = hiera("apache_mod_autoindex")
    $mod_cache            = hiera("apache_mod_cache")
    $mod_cgi              = hiera("apache_mod_cgi")
    $mod_cgid             = hiera("apache_mod_cgid")
    $mod_deflate          = hiera("apache_mod_deflate")
    $mod_dir              = hiera("apache_mod_dir")
    $mod_expires          = hiera("apache_mod_expires")
    $mod_fcgid            = hiera("apache_mod_fcgid")
    $mod_headers          = hiera("apache_mod_headers")
    $mod_include          = hiera("apache_mod_include")
    $mod_ldap             = hiera("apache_mod_authldap")
    $mod_mime             = hiera("apache_mod_mime")
    $mod_negotiation      = hiera("apache_mod_negotiation")
    $mod_php              = hiera("apache_mod_php")
    $mod_proxy_ajp        = hiera("apache_mod_proxy_ajp")
    $mod_proxy_balancer   = hiera("apache_mod_proxy_balancer")
    $mod_proxy_connect    = hiera("apache_mod_proxy_connect")
    $mod_proxy_ftp        = hiera("apache_mod_proxy_ftp")
    $mod_proxy_http       = hiera("apache_mod_proxy_http")
    $mod_python           = hiera("apache_mod_python")
    $mod_reqtimeout       = hiera("apache_mod_reqtimeout")
    $mod_rewrite          = hiera("apache_mod_rewrite")
    $mod_security         = hiera("apache_mod_security")
    $mod_setenvif         = hiera("apache_mod_setenvif")
    $mod_status_check     = hiera("apache_mod_status")
    $mod_svn              = hiera("apache_mod_svn")
    $mod_userdir          = hiera("apache_mod_userdir")
    $mod_wsgi             = hiera("apache_mod_wsgi")
    $mod_xsendfile        = hiera("apache_mod_xsendfile")
    $mpm                  = hiera("apache_mpm")
    $munin_conf_dir       = hiera("munin_conf_dir")
    $munin_monitored      = hiera("apache_munin")
    $munin_probes         = hiera("apache_munin_probes")
    $munin_service_name   = hiera("munin_node_service_name")
    $office_netids        = hiera("office_netids")
    $office_networks      = hiera("office_networks")
    $owsap_security       = hiera("apache_mod_security_owsap")
    $pki_master           = hiera("pki_master")
    $repo                 = hiera("puppet_http_repo")
    $run_dir              = hiera("apache_run_dir")
    $runtime_group        = hiera("apache_runtime_group")
    $runtime_user         = hiera("apache_runtime_user")
    $rsyslog_conf_dir     = hiera("rsyslog_conf_dir")
    $rsyslog_service_name = hiera("rsyslog_service_name")
    $rsyslog_version      = hiera("rsyslog_version")
    $search_group_base    = hiera("apache_searchgroup")
    $search_user_base     = hiera("apache_searchuser")
    $sendfilepath         = hiera("apache_mod_xsendfile_paths")
    $server_admin         = hiera("apache_serveradmin")
    $service_name         = hiera("apache_service_name")
    $timeout              = hiera("apache_timeout")
    $with_collectd        = hiera("apache_collectd")
    $web_root             = hiera("apache_web_root")

    if ($lsbdistcodename == "jessie" or $lsbdistcodename == "trusty") {
	$version = "2.4"
    } else {
	$version = "2.2"
    }
    if ($mod_proxy_ajp or $mod_proxy_balancer or $mod_proxy_connect
	or $mod_proxy_ftp or $mod_proxy_http) {
	$mod_proxy = true
    } else {
	$mod_proxy = false
    }
    if ($munin_monitored or $with_collectd or $mod_proxy_balancer) {
	$mod_status = true
    } else {
	$mod_status = $mod_status_check
    }
    if ($apache_rsyslog) {
	$rotate = 7
    } else {
	$rotate = 56
    }
    if (defined(Class["Openldap"])) {
	$ldap_slave = $fqdn
    } else {
	$ldap_slave = $ldap_slave_check
    }
}
