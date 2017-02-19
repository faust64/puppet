class certbot::vars {
    $apache_dir          = hiera("apache_conf_dir")
    $apache_service_name = hiera("apache_service_name")
    $contact             = hiera("letsencrypt_contact")
    $nginx_dir           = hiera("nginx_conf_dir")
    $postfix_dir         = hiera("postfix_conf_dir")
    $slack_hook          = hiera("letsencrypt_slack_hook_uri")
    $renew_day           = hiera("letsencrypt_renew_day")
    $renew_hour          = hiera("letsencrypt_renew_hour")
    $renew_min           = hiera("letsencrypt_renew_min")
}
