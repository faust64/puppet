class nginx::vars {
    $all_networks         = lookup("vlan_database", {merge => hash})
    $allow_privates       = lookup("apache_allow_privates")
    $cgi_socket           = lookup("nginx_cgi_socket")
    $csp_policies         = lookup("csp_policy_inventory")
    $csp_report           = lookup("csp_report")
    $csp_sources          = lookup("csp_sources")
    $conf_dir             = lookup("nginx_conf_dir")
    $do_letsencrypt       = lookup("apache_letsencrypt")
    $download             = lookup("download_cmd")
    $error_dir            = "$conf_dir/error"
    $hpkp_max_age         = lookup("hpkp_max_age")
    $hpkp_report          = lookup("hpkp_report")
    $keepalive            = lookup("nginx_keepalive_timeout")
    $listen_ports         = lookup("apache_listen_ports")
    $local_networks       = lookup("active_vlans")
    $log_dir              = lookup("nginx_log_dir")
    $log_group            = lookup("gid_adm")
    $log_user             = "root"
    $munin_conf_dir       = lookup("munin_conf_dir")
    $munin_monitored      = lookup("nginx_munin")
    $munin_probes         = lookup("nginx_munin_probes")
    $munin_service_name   = lookup("munin_node_service_name")
    $name_hash_bsize      = lookup("nginx_names_hash_bucket_size")
    $nginx_rsyslog        = lookup("nginx_rsyslog")
    $nginx_run_dir        = lookup("nginx_run_dir")
    $office_netids        = lookup("office_netids")
    $office_networks      = lookup("office_networks")
    $pki_master           = lookup("pki_master")
    $public_key_pins      = lookup("public_key_pins")
    $repo                 = lookup("puppet_http_repo")
    $runtime_group        = lookup("nginx_runtime_group")
    $runtime_user         = lookup("nginx_runtime_user")
    $rsyslog_conf_dir     = lookup("rsyslog_conf_dir")
    $rsyslog_service_name = lookup("rsyslog_service_name")
    $rsyslog_version      = lookup("rsyslog_version")
    $web_root             = lookup("apache_web_root")
    $with_cgi             = lookup("nginx_with_cgi")
    $with_collectd        = lookup("nginx_collectd")
    $worker_connections   = lookup("nginx_worker_connections")
    $worker_processes     = lookup("nginx_worker_processes")

    if ($nginx_rsyslog) {
	$rotate = 7
    } else {
	$rotate = 56
    }
}
