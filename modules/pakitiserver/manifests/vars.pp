class pakitiserver::vars {
    $apache_conf_dir     = hiera("apache_conf_dir")
    $apache_group        = hiera("apache_runtime_group")
    $db_passphrase       = hiera("pakiti_db_passphrase")
    $db_user             = hiera("pakiti_db_user")
    $download            = hiera("download_cmd")
    $http_passphrase     = hiera("pakiti_http_passphrase")
    $http_user           = hiera("pakiti_http_user")
    $rdomain             = hiera("root_domain")
    $web_admins          = hiera("pakiti_admins")
}
