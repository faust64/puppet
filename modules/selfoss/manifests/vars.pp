class selfoss::vars {
    $db_backend   = lookup("selfoss_db_backend")
    $db_host      = "localhost"
    $db_pass      = lookup("selfoss_mysql_passphrase")
    $db_user      = lookup("selfoss_mysql_user")
    $download     = lookup("download_cmd")
    $rdomain      = lookup("root_domain")
    $runtime_user = lookup("apache_runtime_user")
    $web_root     = lookup("apache_web_root")
}
