class unbound::vars {
    $conf_dir           = hiera("unbound_conf_dir")
    $do_cache           = hiera("unbound_do_cache")
    $do_dnssec          = hiera("unbound_do_dnssec")
    $do_public          = hiera("unbound_do_public")
    $download           = hiera("download_cmd")
    $fail2ban_unbound   = hiera("fail2ban_do_unbound")
    $forwards           = hiera("unbound_forwarders")
    $munin_conf_dir     = hiera("munin_conf_dir")
    $munin_monitored    = hiera("unbound_munin")
    $munin_probes       = hiera("unbound_munin_probes")
    $munin_service_name = hiera("munin_node_service_name")
    $mypixeladdress     = hiera("unbound_pixel_address")
    $recurse_networks   = hiera("unbound_recurse_networks")
    $rdomain            = hiera("root_domain")
    $rotate             = hiera("unbound_rotate")
    $run_dir            = hiera("unbound_run_dir")
    $runtime_group      = hiera("unbound_runtime_group")
    $runtime_user       = hiera("unbound_runtime_user")
    $var_dir            = hiera("unbound_var_dir")
    $with_collectd      = hiera("unbound_collectd")

    if ($mypixeladdress) {
	$pixeladdress   = $mypixeladdress
    } else {
	$pixeladdress   = $ipaddress
    }
}
