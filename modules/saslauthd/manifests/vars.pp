class saslauthd::vars {
    $conf_dir          = hiera("saslauthd_conf_dir")
    $ldap_passphrase   = hiera("saslauthd_ldap_passphrase")
    $ldap_slave        = hiera("openldap_ldap_slave")
    $ldap_user         = hiera("saslauthd_ldap_user")
    $mech_list         = hiera("saslauthd_mech_list")
    $postfix_conf_dir  = hiera("postfix_conf_dir")
    $postfix_spool_dir = hiera("postfix_spool_dir")
    $routeto           = hiera("postfix_routeto")
    $search_base       = hiera("saslauthd_search_base")
    $search_filter     = hiera("saslauthd_search_filter")
    $run_dir           = hiera("saslauthd_run_dir")
}
