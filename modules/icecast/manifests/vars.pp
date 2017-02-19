class icecast::vars {
    $admin_pass    = hiera("icecast_admin_passphrase")
    $admin_user    = hiera("icecast_admin_user")
    $codir_pass    = hiera("icecast_codir_passphrase")
    $codir_user    = hiera("icecast_codir_user")
    $conf_dir      = hiera("icecast_conf_dir")
    $log_dir       = hiera("icecast_log_dir")
    $relay_pass    = hiera("icecast_relay_passphrase")
    $relay_user    = hiera("icecast_relay_user")
    $runtime_group = hiera("icecast_runtime_group")
    $runtime_user  = hiera("icecast_runtime_user")
    $service_name  = hiera("icecast_service_name")
    $share_dir     = hiera("icecast_share_dir")
    $upstream      = hiera("icecast_upstream")

    $max_clients = 100
    if ($upstream) {
	$max_sources = 1
    }
    else {
	$max_sources = 10
    }
}
