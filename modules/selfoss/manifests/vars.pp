class selfoss::vars {
    $db_backend   = hiera("selfoss_db_backend")
    $db_host      = "localhost"
    $db_pass      = hiera("selfoss_mysql_passphrase")
    $db_user      = hiera("selfoss_mysql_user")
    $download     = hiera("download_cmd")
    $rdomain      = hiera("root_domain")
    $runtime_user = hiera("apache_runtime_user")
    $web_root     = hiera("apache_web_root")
}
