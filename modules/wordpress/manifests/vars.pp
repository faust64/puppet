class wordpress::vars {
    $apache_log_dir    = hiera("apache_log_dir")
    $conf_dir          = hiera("wordpress_conf_dir")
    $db_host           = hiera("wordpress_db_host")
    $db_name           = hiera("wordpress_db_name")
    $db_pass           = hiera("wordpress_db_pass")
    $db_user           = hiera("wordpress_db_user")
    $download          = hiera("download_cmd")
    $key_auth          = hiera("wordpress_key_auth")
    $key_secure_auth   = hiera("wordpress_key_secure_auth")
    $key_logged_in     = hiera("wordpress_key_logged_in")
    $key_nonce         = hiera("wordpress_key_nonce")
    $key_salt          = hiera("wordpress_key_salt")
    $key_secure_salt   = hiera("wordpress_key_secure_salt")
    $lib_dir           = hiera("wordpress_var_dir")
    $listen_ports      = hiera("apache_listen_ports")
    $nagios_rdomain    = hiera("wordpress_nagios_check_rdomain")
    $rdomain           = hiera("root_domain")
    $salt_logged_in    = hiera("wordpress_salt_logged_in")
    $salt_nonce        = hiera("wordpress_salt_nonce")
    $slack_hook        = hiera("wordpress_slack_hook_uri")
    $srvname_alias     = hiera("wordpress_network_aliases")
    $srvname_check     = hiera("wordpress_server_name")
    $usr_dir           = hiera("wordpress_usr_dir")
    $wpauthdir_version = "1.7.6"
    $wp_network        = hiera("wordpress_do_network")

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
