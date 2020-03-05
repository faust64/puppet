class nextcloud::vars {
    $domains        = lookup("nextcloud_domains")
    $db_backend     = lookup("nextcloud_db_backend")
    $db_host        = lookup("nextcloud_db_host")
    $db_name        = lookup("nextcloud_db_name")
    $db_pass        = lookup("nextcloud_db_passphrase")
    $db_tableprefix = lookup("nextcloud_db_tableprefix")
    $db_user        = lookup("nextcloud_db_user")
    $do_backup      = lookup("nextcloud_do_backup")
    $instance_id    = lookup("nextcloud_instance_id")
    $mail_domain    = lookup("nextcloud_mail_domain")
    $mail_from      = lookup("nextcloud_mail_from")
    $password_salt  = lookup("nextcloud_password_salt")
    $php_apc        = lookup("php_apc")
    $rdomain        = lookup("root_domain")
    $runtime_group  = lookup("apache_runtime_group")
    $runtime_user   = lookup("apache_runtime_user")
    $secret         = lookup("nextcloud_secret")
    $theme          = lookup("nextcloud_theme")
    $version        = lookup("nextcloud_version")
    $web_listen     = lookup("apache_listen_ports")
    $web_root       = lookup("nextcloud_web_root")

    if ($web_listen['ssl'] == false) {
	$rewrite_proto = "http"
    } else {
	$rewrite_proto = "https"
    }
}
