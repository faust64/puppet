class syslog::vars {
    $apache_log_dir       = lookup("apache_log_dir")
    $apache_run_dir       = lookup("apache_run_dir")
    $apache_srvname       = lookup("apache_service_name")
    $generic_group        = lookup("generic_group")
    $generic_user         = lookup("generic_user")
    $munin_log_dir        = lookup("munin_log_dir")
    $munin_run_dir        = lookup("munin_run_dir")
    $newsyslog_cmd        = lookup("newsyslog_cmd")
    $nginx_log_dir        = lookup("nginx_log_dir")
    $nginx_runtime_group  = lookup("nginx_runtime_group")
    $nginx_runtime_user   = lookup("nginx_runtime_user")
    $pg_data_dir          = lookup("postgres_data_dir")
    $pg_runtime_group     = lookup("postgres_runtime_group")
    $pg_runtime_user      = lookup("postgres_runtime_user")
    $slim_run_dir         = lookup("slim_run_dir")
    $syslog_retransmit_ip = lookup("rsyslog_hub")

    if (defined(Class["apache"])) {
	$has_apache = true
    }
    else {
	$has_apache = false
    }
    if (defined(Class["muninnode"])) {
	$has_munin = true
    }
    else {
	$has_munin = false
    }
    if (defined(Class["postgres"])) {
	$has_psql = true
    }
    else {
	$has_psql = false
    }
    if (defined(Class["camtrace"])) {
	$has_camtrace = true
    }
    else {
	$has_camtrace = false
    }
    if (defined(Class["nginx"])) {
	$has_nginx = true
    }
    else {
	$has_nginx = false
    }
    if (defined(Class["sendmail"])) {
	$has_sendmail = true
    }
    else {
	$has_sendmail = false
    }
    if (defined(Class["slim"])) {
	$has_slim = true
    }
    else {
	$has_slim = false
    }
}
