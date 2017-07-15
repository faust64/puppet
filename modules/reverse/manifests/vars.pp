class reverse::vars {
    $apache_conf_dir  = lookup("apache_conf_dir")
    $apache_conf_file = lookup("apache_conf_file")
    $domains          = lookup("reverse_domains")
    $ldap_slave       = lookup("openldap_ldap_slave")
    $ldap_user        = lookup("apache_searchuser")
    $root_domain      = lookup("root_domain")
    $serveradmin      = lookup("apache_serveradmin")

    if ($domains != false) {
	$collect = $domains
    } else {
	$collect = [ $domain ]
    }
}
