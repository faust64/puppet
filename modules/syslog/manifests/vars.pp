class syslog::vars {
    $apache_log_dir       = hiera("apache_log_dir")
    $apache_run_dir       = hiera("apache_run_dir")
    $apache_srvname       = hiera("apache_service_name")
    $generic_group        = hiera("generic_group")
    $generic_user         = hiera("generic_user")
    $munin_log_dir        = hiera("munin_log_dir")
    $munin_run_dir        = hiera("munin_run_dir")
    $newsyslog_cmd        = hiera("newsyslog_cmd")
    $nginx_log_dir        = hiera("nginx_log_dir")
    $nginx_runtime_group  = hiera("nginx_runtime_group")
    $nginx_runtime_user   = hiera("nginx_runtime_user")
    $pg_data_dir          = hiera("postgres_data_dir")
    $pg_runtime_group     = hiera("postgres_runtime_group")
    $pg_runtime_user      = hiera("postgres_runtime_user")
    $slim_run_dir         = hiera("slim_run_dir")
    $syslog_retransmit_ip = hiera("rsyslog_hub")

    if (defined(Class[Apache])) {
	$has_apache = true
    }
    else {
	$has_apache = false
    }
    if (defined(Class[Muninnode])) {
	$has_munin = true
    }
    else {
	$has_munin = false
    }
    if (defined(Class[Postgres])) {
	$has_psql = true
    }
    else {
	$has_psql = false
    }
    if (defined(Class[Camtrace])) {
	$has_camtrace = true
    }
    else {
	$has_camtrace = false
    }
    if (defined(Class[Nginx])) {
	$has_nginx = true
    }
    else {
	$has_nginx = false
    }
    if (defined(Class[Sendmail])) {
	$has_sendmail = true
    }
    else {
	$has_sendmail = false
    }
    if (defined(Class[Slim])) {
	$has_slim = true
    }
    else {
	$has_slim = false
    }
}
