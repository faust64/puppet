class saslauthd::vars {
    $conf_dir          = lookup("saslauthd_conf_dir")
    $ldap_passphrase   = lookup("saslauthd_ldap_passphrase")
    $ldap_slave        = lookup("openldap_ldap_slave")
    $ldap_user         = lookup("saslauthd_ldap_user")
    $mech_list         = lookup("saslauthd_mech_list")
    $postfix_conf_dir  = lookup("postfix_conf_dir")
    $postfix_spool_dir = lookup("postfix_spool_dir")
    $routeto           = lookup("postfix_routeto")
    $search_base       = lookup("saslauthd_search_base")
    $search_filter     = lookup("saslauthd_search_filter")
    $run_dir           = lookup("saslauthd_run_dir")
}
