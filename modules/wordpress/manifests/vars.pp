class wordpress::vars {
    $apache_log_dir    = lookup("apache_log_dir")
    $conf_dir          = lookup("wordpress_conf_dir")
    $db_host           = lookup("wordpress_db_host")
    $db_name           = lookup("wordpress_db_name")
    $db_pass           = lookup("wordpress_db_pass")
    $db_user           = lookup("wordpress_db_user")
    $key_auth          = lookup("wordpress_key_auth")
    $key_secure_auth   = lookup("wordpress_key_secure_auth")
    $key_logged_in     = lookup("wordpress_key_logged_in")
    $key_nonce         = lookup("wordpress_key_nonce")
    $key_salt          = lookup("wordpress_key_salt")
    $key_secure_salt   = lookup("wordpress_key_secure_salt")
    $lib_dir           = lookup("wordpress_var_dir")
    $listen_ports      = lookup("apache_listen_ports")
    $nagios_rdomain    = lookup("wordpress_nagios_check_rdomain")
    $rdomain           = lookup("root_domain")
    $salt_logged_in    = lookup("wordpress_salt_logged_in")
    $salt_nonce        = lookup("wordpress_salt_nonce")
    $slack_hook        = lookup("wordpress_slack_hook_uri")
    $srvname_alias     = lookup("wordpress_network_aliases")
    $srvname_check     = lookup("wordpress_server_name")
    $usr_dir           = lookup("wordpress_usr_dir")
    $wpauthdir_version = "1.7.6"
    $wp_network        = lookup("wordpress_do_network")

    $srvname           = "${srvname_check}.$domain"
    if ($domain != $rdomain) {
	$proxyname     = "${srvname_check}.$rdomain"
    } else {
	$proxyname     = false
    }
    if ($wp_network == true) {
	$aliases       = split(inline_template("<% @srvname_alias.each do |host| -%><%=host%>.<%=@domain%>,<%=host%>.<%=@rdomain%>,<% end -%><%=@proxyname%>"), ',')
    } elsif ($proxyname) {
	$aliases       = [ $proxyname ]
    } else {
	$aliases       = false
    }
}
