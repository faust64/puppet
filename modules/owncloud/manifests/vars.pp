class owncloud::vars {
    $domains        = hiera("owncloud_domains")
    $db_backend     = hiera("owncloud_db_backend")
    $db_host        = hiera("owncloud_db_host")
    $db_name        = hiera("owncloud_db_name")
    $db_pass        = hiera("owncloud_db_passphrase")
    $db_tableprefix = hiera("owncloud_db_tableprefix")
    $db_user        = hiera("owncloud_db_user")
    $do_backup      = hiera("owncloud_do_backup")
    $instance_id    = hiera("owncloud_instance_id")
    $mail_domain    = hiera("owncloud_mail_domain")
    $mail_from      = hiera("owncloud_mail_from")
    $password_salt  = hiera("owncloud_password_salt")
    $php_apc        = hiera("php_apc")
    $rdomain        = hiera("root_domain")
    $runtime_group  = hiera("apache_runtime_group")
    $runtime_user   = hiera("apache_runtime_user")
    $secret         = hiera("owncloud_secret")
    $theme          = hiera("owncloud_theme")
    $version        = hiera("owncloud_version")
    $web_listen     = hiera("apache_listen_ports")
    $web_root       = hiera("owncloud_web_root")

    if ($web_listen['ssl'] == false) {
	$rewrite_proto = "http"
    } else {
	$rewrite_proto = "https"
    }
}
