class racktables::vars {
    $auth_backend = lookup("racktables_auth_backend")
    $conf_dir     = lookup("apache_conf_dir")
    $db_pass      = lookup("racktables_database_passphrase")
    $db_user      = lookup("racktables_database_user")
    $ldap_slave   = lookup("openldap_ldap_slave")
    $ldap_suffix  = lookup("racktables_ldap_suffix")
    $munin_host   = lookup("munin_vhost_name")
    $rdomain      = lookup("root_domain")
    $service_name = lookup("apache_service_name")
    $version      = lookup("racktables_version")
    $web_root     = lookup("apache_web_root")
    $wwwgroup     = lookup("apache_runtime_group")
}
