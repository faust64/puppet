class apache::vars {
    $all_networks         = lookup("vlan_database", {merge => hash})
    $allow_privates       = lookup("apache_allow_privates")
    $apache_debugs        = lookup("apache_debugs")
    $apache_rsyslog       = lookup("apache_rsyslog")
    $charset              = lookup("locale_charset")
    $conf_dir             = lookup("apache_conf_dir")
    $conf_file            = lookup("apache_conf_file")
    $csp_policies         = lookup("csp_policy_inventory")
    $csp_report           = lookup("csp_report")
    $csp_sources          = lookup("csp_sources")
    $download             = lookup("download_cmd")
    $do_letsencrypt       = lookup("apache_letsencrypt")
    $keepalive            = lookup("apache_keepalive")
    $keepalive_timeout    = lookup("apache_keepalive_timeout")
    $error_dir            = lookup("apache_error_dir")
    $hpkp_max_age         = lookup("hpkp_max_age")
    $hpkp_report          = lookup("hpkp_report")
    $icons_dir            = lookup("apache_icons_dir")
    $ldap_slave_check     = lookup("openldap_ldap_slave")
    $listen_ports         = lookup("apache_listen_ports")
    $local_networks       = lookup("active_vlans")
    $log_dir              = lookup("apache_log_dir")
    $log_group            = lookup("gid_adm")
    $log_user             = "root"
    $maintenance          = lookup("apache_maintenance")
    $max_keepalive_req    = lookup("apache_max_keepalive_req")
    $modules_dir          = lookup("apache_modules_dir")
    $mod_actions          = lookup("apache_mod_actions")
    $mod_alias            = lookup("apache_mod_alias")
    $mod_autoindex        = lookup("apache_mod_autoindex")
    $mod_cache            = lookup("apache_mod_cache")
    $mod_cgi              = lookup("apache_mod_cgi")
    $mod_cgid             = lookup("apache_mod_cgid")
    $mod_deflate          = lookup("apache_mod_deflate")
    $mod_dir              = lookup("apache_mod_dir")
    $mod_expires          = lookup("apache_mod_expires")
    $mod_fcgid            = lookup("apache_mod_fcgid")
    $mod_headers          = lookup("apache_mod_headers")
    $mod_include          = lookup("apache_mod_include")
    $mod_ldap             = lookup("apache_mod_authldap")
    $mod_mime             = lookup("apache_mod_mime")
    $mod_negotiation      = lookup("apache_mod_negotiation")
    $mod_php              = lookup("apache_mod_php")
    $mod_proxy_ajp        = lookup("apache_mod_proxy_ajp")
    $mod_proxy_balancer   = lookup("apache_mod_proxy_balancer")
    $mod_proxy_connect    = lookup("apache_mod_proxy_connect")
    $mod_proxy_ftp        = lookup("apache_mod_proxy_ftp")
    $mod_proxy_http       = lookup("apache_mod_proxy_http")
    $mod_python           = lookup("apache_mod_python")
    $mod_reqtimeout       = lookup("apache_mod_reqtimeout")
    $mod_rewrite          = lookup("apache_mod_rewrite")
    $mod_security         = lookup("apache_mod_security")
    $mod_setenvif         = lookup("apache_mod_setenvif")
    $mod_status_check     = lookup("apache_mod_status")
    $mod_svn              = lookup("apache_mod_svn")
    $mod_userdir          = lookup("apache_mod_userdir")
    $mod_wsgi             = lookup("apache_mod_wsgi")
    $mod_xsendfile        = lookup("apache_mod_xsendfile")
    $mpm                  = lookup("apache_mpm")
    $munin_conf_dir       = lookup("munin_conf_dir")
    $munin_monitored      = lookup("apache_munin")
    $munin_probes         = lookup("apache_munin_probes")
    $munin_service_name   = lookup("munin_node_service_name")
    $office_netids        = lookup("office_netids")
    $office_networks      = lookup("office_networks")
    $owsap_security       = lookup("apache_mod_security_owsap")
    $pki_master           = lookup("pki_master")
    $repo                 = lookup("puppet_http_repo")
    $run_dir              = lookup("apache_run_dir")
    $runtime_group        = lookup("apache_runtime_group")
    $runtime_user         = lookup("apache_runtime_user")
    $rsyslog_conf_dir     = lookup("rsyslog_conf_dir")
    $rsyslog_service_name = lookup("rsyslog_service_name")
    $rsyslog_version      = lookup("rsyslog_version")
    $search_group_base    = lookup("apache_searchgroup")
    $search_user_base     = lookup("apache_searchuser")
    $sendfilepath         = lookup("apache_mod_xsendfile_paths")
    $server_admin         = lookup("apache_serveradmin")
    $service_name         = lookup("apache_service_name")
    $timeout              = lookup("apache_timeout")
    $with_collectd        = lookup("apache_collectd")
    $web_root             = lookup("apache_web_root")

    if ($lsbdistcodename == "stretch" or $lsbdistcodename == "jessie" or $lsbdistcodename == "trusty") {
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
