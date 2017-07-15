class certbot::vars {
    $apache_dir          = lookup("apache_conf_dir")
    $apache_service_name = lookup("apache_service_name")
    $contact             = lookup("letsencrypt_contact")
    $nginx_dir           = lookup("nginx_conf_dir")
    $postfix_dir         = lookup("postfix_conf_dir")
    $slack_hook          = lookup("letsencrypt_slack_hook_uri")
    $renew_day           = lookup("letsencrypt_renew_day")
    $renew_hour          = lookup("letsencrypt_renew_hour")
    $renew_min           = lookup("letsencrypt_renew_min")
}
