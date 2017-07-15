class owncloud::vars {
    $domains        = lookup("owncloud_domains")
    $db_backend     = lookup("owncloud_db_backend")
    $db_host        = lookup("owncloud_db_host")
    $db_name        = lookup("owncloud_db_name")
    $db_pass        = lookup("owncloud_db_passphrase")
    $db_tableprefix = lookup("owncloud_db_tableprefix")
    $db_user        = lookup("owncloud_db_user")
    $do_backup      = lookup("owncloud_do_backup")
    $instance_id    = lookup("owncloud_instance_id")
    $mail_domain    = lookup("owncloud_mail_domain")
    $mail_from      = lookup("owncloud_mail_from")
    $password_salt  = lookup("owncloud_password_salt")
    $php_apc        = lookup("php_apc")
    $rdomain        = lookup("root_domain")
    $runtime_group  = lookup("apache_runtime_group")
    $runtime_user   = lookup("apache_runtime_user")
    $secret         = lookup("owncloud_secret")
    $theme          = lookup("owncloud_theme")
    $version        = lookup("owncloud_version")
    $web_listen     = lookup("apache_listen_ports")
    $web_root       = lookup("owncloud_web_root")

    if ($web_listen['ssl'] == false) {
	$rewrite_proto = "http"
    } else {
	$rewrite_proto = "https"
    }
}
