class opennebula::vars {
    $datastore0          = hiera("nebula_datastore0")
    $db_backend          = hiera("nebula_db_backend")
    $db_pass             = hiera("nebula_db_passphrase")
    $db_user             = hiera("nebula_db_user")
    $ldap_base           = hiera("nebula_searchuser")
    $ldap_slave          = hiera("openldap_ldap_slave")
    $nebula_class        = hiera("nebula_class")
    $nagios_conf_dir     = hiera("nagios_conf_dir")
    $nagios_runtime_user = hiera("nagios_runtime_user")
    $runtime_group       = hiera("nebula_runtime_group")
    $runtime_user        = hiera("nebula_runtime_user")
    $version             = hiera("nebula_version")
}
