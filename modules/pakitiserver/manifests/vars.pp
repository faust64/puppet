class pakitiserver::vars {
    $apache_conf_dir     = lookup("apache_conf_dir")
    $apache_group        = lookup("apache_runtime_group")
    $db_passphrase       = lookup("pakiti_db_passphrase")
    $db_user             = lookup("pakiti_db_user")
    $http_passphrase     = lookup("pakiti_http_passphrase")
    $http_user           = lookup("pakiti_http_user")
    $rdomain             = lookup("root_domain")
    $web_admins          = lookup("pakiti_admins")
}
