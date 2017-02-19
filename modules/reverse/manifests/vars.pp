class reverse::vars {
    $apache_conf_dir  = hiera("apache_conf_dir")
    $apache_conf_file = hiera("apache_conf_file")
    $domains          = hiera("reverse_domains")
    $ldap_slave       = hiera("openldap_ldap_slave")
    $ldap_user        = hiera("apache_searchuser")
    $root_domain      = hiera("root_domain")
    $serveradmin      = hiera("apache_serveradmin")

    if ($domains != false) {
	$collect = $domains
    } else {
	$collect = [ $domain ]
    }
}
