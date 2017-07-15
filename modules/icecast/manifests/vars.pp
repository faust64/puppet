class icecast::vars {
    $admin_pass    = lookup("icecast_admin_passphrase")
    $admin_user    = lookup("icecast_admin_user")
    $codir_pass    = lookup("icecast_codir_passphrase")
    $codir_user    = lookup("icecast_codir_user")
    $conf_dir      = lookup("icecast_conf_dir")
    $log_dir       = lookup("icecast_log_dir")
    $relay_pass    = lookup("icecast_relay_passphrase")
    $relay_user    = lookup("icecast_relay_user")
    $runtime_group = lookup("icecast_runtime_group")
    $runtime_user  = lookup("icecast_runtime_user")
    $service_name  = lookup("icecast_service_name")
    $share_dir     = lookup("icecast_share_dir")
    $upstream      = lookup("icecast_upstream")

    $max_clients = 100
    if ($upstream) {
	$max_sources = 1
    }
    else {
	$max_sources = 10
    }
}
