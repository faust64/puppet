class tinytinyrss::vars {
    $db_backend   = lookup("tinytinyrss_db_backend")
    $db_pass      = lookup("tinytinyrss_mysql_passphrase")
    $db_user      = lookup("tinytinyrss_mysql_user")
    $download     = lookup("download_cmd")
    $rdomain      = lookup("root_domain")
    $runtime_user = lookup("apache_runtime_user")
    $web_root     = lookup("apache_web_root")
}
