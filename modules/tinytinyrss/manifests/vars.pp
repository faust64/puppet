class tinytinyrss::vars {
    $db_backend   = hiera("tinytinyrss_db_backend")
    $db_pass      = hiera("tinytinyrss_mysql_passphrase")
    $db_user      = hiera("tinytinyrss_mysql_user")
    $download     = hiera("download_cmd")
    $rdomain      = hiera("root_domain")
    $runtime_user = hiera("apache_runtime_user")
    $web_root     = hiera("apache_web_root")
}
